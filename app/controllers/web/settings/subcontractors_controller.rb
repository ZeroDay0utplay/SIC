class Web::Settings::SubcontractorsController < Web::ApplicationController
  before_action :set_subcontractor, only: [:assign_agents_to_subcontractor, :create_agent, :add_agents, :get_agents,
    :search_agents, :edit, :update, :destroy]

  def index
    items = params[:items] || 10
    @q = Subcontractor.current_company.with_attached_logo.ransack(params[:q])
    @subcontractors = @q.result.paginate(page: params[:page], per_page: items)
    @count = @subcontractors.count

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def get_agents
    @q = @subcontractor.agents.ransack(params[:q])
    @agents = @q.result

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/subcontractors/agent_modal")
      end
      format.html
    end
  end

  def search_agents
    @q = @subcontractor.agents.ransack(params[:q])
    @agents = @q.result
    @count = @agents.count

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("cover-agents-subcontractor", partial: "web/settings/subcontractors/agent_list", locals: {agents: @agents, count: @count})
      end
    end
  end

  def new
    @subcontractor = Subcontractor.new

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @subcontractor = Subcontractor.new(subcontractor_params)

    if @subcontractor.save
      redirect_to add_agents_settings_subcontractor_path(@subcontractor)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @subcontractor.update(subcontractor_params)
      redirect_to add_agents_settings_subcontractor_path(@subcontractor)
    else
      render :edit
    end
  end

  def add_agents
    @subcontractor_agent = @subcontractor.agents.build
    @agents = @subcontractor.agents
  end

  def create_agent
    @subcontractor_agent = @subcontractor.agents.build(subcontractor_agent_params)

    if @subcontractor_agent.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.prepend("agents-list", partial: "web/settings/subcontractors/agent", locals: {agent: @subcontractor_agent})
        end
        format.html { redirect_to settings_subcontractors_path, flash: {success: "Agent ajouté avec succès."} }
      end
    else
      render :add_agents
    end
  end

  def assign_agents_to_subcontractor
    selected_agent_ids = params[:selected_agents] || []
    selected_agents = SubcontractorAgent.where(id: selected_agent_ids)

    selected_agents.each do |agent|
      @subcontractor.subcontractor_agents.create(agent: agent) unless @subcontractor.agents.include?(agent)
    end

    redirect_to settings_subcontractors_path, flash: {success: "Les agents sélectionnés ont été affectés avec succès."}
  end

  def destroy
    @subcontractor.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("subcontractor-#{@subcontractor.id}")
      end
      format.html
    end
  end

  private

  def set_subcontractor
    @subcontractor = Subcontractor.find(params[:id])
  end

  def subcontractor_params
    params.require(:subcontractor).permit(:company_name, :manager, :logo, :email, :phone, :color, :active, :subcontractor_skills)
  end

  def subcontractor_agent_params
    params.require(:subcontractor_agent).permit(:first_name, :last_name, :email, :phone)
  end
end
