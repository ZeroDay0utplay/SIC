class Web::Settings::SkillsController < Web::ApplicationController
  before_action :set_skill, only: %i[edit update destroy]

  def index
    items = params[:items] || 10
    @q = Skill.current_company.order(:name).ransack(params[:q])

    @skills = @q.result.paginate(page: params[:page], per_page: items)
    @skill = Skill.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      flash.now["success"] = "La compétence a été créée avec succès"
      respond_to do |format|
        format.html { redirect_to settings_skills_path }
        format.turbo_stream
      end
    end
  end

  def check_name
    skill_exists = Skill.current_company.exists?(name: params[:name])
    render json: {exists: skill_exists}
  end

  def edit
    @skill = Skill.find(params[:id])
  end

  def update
    @skill = Skill.find(params[:id])

    if @skill.update(skill_params)
      respond_to do |format|
        format.html { render json: @skill }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render json: {errors: @skill.errors.full_messages} }
        format.turbo_stream
      end
    end
  end

  def destroy
    @skill.destroy

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_skill
    @skill = Skill.find(params[:id])
  end

  def skill_params
    params.require(:skill).permit(:name)
  end
end
