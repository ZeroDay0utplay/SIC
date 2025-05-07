class Web::Plannings::RegularsController < Web::ApplicationController
  before_action :check_owner_regulars, :set_regular, only: [:edit, :update, :destroy, :manage_tasks_agents]

  def index
    items = params.fetch(:items, 10).to_i

    @regulars = Regular.current_company.includes(:client, :prestation, intervention: [:address])

    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date])
      end_date = Date.parse(params[:end_date])

      @regulars = @regulars.where(start_on: start_date..end_date)
                            .where(finish_on: start_date..end_date)

    end

    @regulars = @regulars.paginate(page: params[:page], per_page: items)
    @count = Regular.current_company.all.count
  end

  def edit
  end

  def update
    @regular.update(set_regular_params)

    if @regular.save
      if @regular.tasks.size.zero?
        update_agent_plannings(@regular, params[:regular][:agent_schedule_dates])
        redirect_to plannings_regulars_path(), flash: {success: "Bien été mise à jour"}
      else
        redirect_to manage_tasks_agents_plannings_regular_path(), flash: {success: "Bien été mise à jour"}
      end
    else
      render :edit
    end
  end

  def manage_tasks_agents
  end


  def update_tasks_agents
    # @regular.update(set_regular_params)
    # if @regular.save
    if true
      redirect_to plannings_regulars_path(), flash: {success: "Bien été mise à jour"}
    else
      render :manage_tasks_agents
    end
  end

  def destroy
  end


  def update_agent_plannings(regular, agent_schedule_dates)
    return if agent_schedule_dates.blank?

    begin
      parsed_schedules = parse_schedule_entries(params[:regular][:agent_schedule_dates])

      ActiveRecord::Base.transaction do
        updated_agents = build_agent_date_mapping(parsed_schedules)
        update_schedules(regular, updated_agents)
        cleanup_old_assignments(regular, updated_agents)
      end
    rescue JSON::ParserError, ArgumentError => e
      Rails.logger.error "Error parsing schedule data: #{e.message}"
      raise ActiveRecord::Rollback
    end
  end

  private

  def parse_schedule_entries(entries)
    entries.reject(&:blank?).map do |entry|
      JSON.parse(entry) rescue nil
    end.compact
  end

  def build_agent_date_mapping(parsed_schedules)
    parsed_schedules.each_with_object({}) do |data, hash|
      agent_id = data["agent_id"].to_i
      dates = Array(data["dates"]).map { |d| Date.parse(d) }
      hash[agent_id] = dates
    end
  end

  def update_schedules(regular, updated_agents)
    schedules_by_date = regular.schedules.index_by(&:date)

    updated_agents.each do |agent_id, target_dates|
      target_dates.each do |date|
        schedule = schedules_by_date[date]
        next unless schedule

        schedule.planning_agents.find_or_create_by!(agent_id: agent_id)
      end
    end
  end

  def cleanup_old_assignments(regular, updated_agents)
    regular.schedules.includes(:planning_agents).find_each do |schedule|
      schedule.planning_agents.each do |planning_agent|
        agent_id = planning_agent.agent_id
        date = schedule.date

        unless updated_agents.key?(agent_id) && updated_agents[agent_id].include?(date)
          planning_agent.destroy
        end
      end
    end
  end

  def check_owner_regulars
    @@regular = Regular.find(params[:id])
    unless current_user.company.id == @@regular.company_id
      redirect_to plannings_regulars_path(), flash: {error: "Vous n'avez pas accès à cette ressource"}
    end
  end

  def set_regular
    @regular = Regular.find(params[:id])
  end

  def set_regular_params
    params.require(:regular).permit(:prestation_id, :note, :remark, :needs)
  end
end
