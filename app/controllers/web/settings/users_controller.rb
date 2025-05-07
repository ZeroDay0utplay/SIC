class Web::Settings::UsersController < Web::ApplicationController
  before_action :set_user, only: [:update, :destroy, :edit, :activate, :confirm_activate]
  before_action :set_skills, only: [:agents, :administrators, :new, :edit]

  def index
  end

  def new
    @method_form = :post
    @path = settings_users_path
    @type = params[:type]

    @user = {
      "agents" => Agent,
      "administrators" => Admin
    }.fetch(@type, User).new

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/users/new_user_modal", locals: {user: @user})
      end
      format.html
    end
  end

  def edit
    @method_form = :patch
    @path = settings_user_path(@user)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/users/edit_user_modal", locals: {user: @user})
      end
      format.html
    end
  end

  def update
    user_type = params[:admin] ? :admin : :agent

    ActiveRecord::Base.transaction do
      unless @user.admin?
        skills = params[user_type][:skills]&.compact_blank || []
        add_user_skills(skills)
      end

      @user.company = current_user.company || session[:company_id]

      if @user.update(user_params)
        respond_to do |format|
          format.html
          format.turbo_stream
        end
      else
        respond_to do |format|
          format.html { render :edit }
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "remote_modal",
              partial: "web/settings/users/edit_user_modal",
              locals: {user: @user}
            )
          end
        end
      end
    end
  end

  def add_user_skills(new_skills)
    current_skill_ids = @user.skills.pluck(:id)

    new_skills.each do |skill_id|
      UserSkill.where(user_id: @user.id, skill_id: skill_id).first_or_create
    end

    skills_to_remove = current_skill_ids - new_skills.map(&:to_i)
    UserSkill.where(user_id: @user.id, skill_id: skills_to_remove).destroy_all
  end

  def create
    user_type = params[:admin] ? :admin : :agent
    @user = User.new(user_params)
    @user.company = current_user.company || session[:company_id]

    ActiveRecord::Base.transaction do
      if @user.save
        unless @user.admin?
          skills = params[user_type][:skills]&.compact_blank || []

          add_user_skills(skills) unless skills.empty?
        end
        respond_to do |format|
          format.html
          format.turbo_stream
        end
      else
        respond_to do |format|
          format.html { render :new }
          format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/users/new_user_modal", locals: {user: @user}) }
        end
      end
    end
  end

  def agents
    items = params[:items] || 10

    agents_filtred = Agent.current_company.includes(:photo_attachment).order(created_at: :desc)

    if params[:skills].present?
      agent_ids = UserSkill.where(skill_id: params[:skills]).pluck(:user_id)
      agents_filtred = agents_filtred.where(id: agent_ids)
    end

    if params[:status].present?
      agents_filtred = agents_filtred.where(active: params[:status])
    end

    @q = agents_filtred.ransack(params[:q])

    @count = @q.result.count
    @users = @q.result.paginate(page: params[:page], per_page: items)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def administrators
    items = params[:items] || 10
    admins_filtred = Admin.current_company.includes(:photo_attachment).order(created_at: :desc)

    if params[:status].present?
      admins_filtred = admins_filtred.where(active: params[:status])
    end

    @q = admins_filtred.ransack(params[:q])
    @count = @q.result.count
    @users = @q.result.paginate(page: params[:page], per_page: items)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def confirm_activate
    @confirm_path = activate_settings_user_path(@user)
    respond_to do |format|
      format.turbo_stream do
        if @user.active
          render turbo_stream: turbo_stream.replace("remote_modal",
            partial: "shared/confirm_disactivate_user",
            locals: {confirm_path: @confirm_path})
        else
          render turbo_stream: turbo_stream.replace("remote_modal",
            partial: "shared/confirm_activate_user",
            locals: {confirm_path: @confirm_path})
        end
      end
      format.html
    end
  end

  def activate
    @user.update(active: !@user.active)
    @user.reload
    respond_to do |format|
      format.html
      format.turbo_stream { render :update }
    end
  end

  def destroy
    @user.destroy

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def user_params
    user_type = params[:admin] ? :admin : :agent
    permitted_attributes = [
      :email, :first_name, :last_name, :role, :photo, :job, :type,
      :is_teamleader, :is_driver, :note, :active, :address, :platform, :function, :cin, :identifier
    ]

    permitted_attributes << :password if params[user_type][:password].present?

    params.require(user_type).permit(permitted_attributes)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def set_skills
    @skills = Skill.all
  end
end
