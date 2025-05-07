class Web::NeedsController < Web::ApplicationController
  def new
    @type = params[:type] || "punctual"

    @planning = {
      "punctual" => Punctual,
      "regular" => Regular
    }.fetch(@type, Planning).new

    @url = (@planning.type == "Punctual") ? create_punctual_need_path : create_regular_need_path
  end

  def create_regular
    start_date = Date.parse(params[:regular][:start_on])
    end_date = Date.parse(params[:regular][:finish_on])

    success = true
    errors = []

    if start_date.month == end_date.month && start_date.year == end_date.year
      success, errors = create_single_regular(start_date, end_date, params[:regular])
    else
      success, errors = create_multiple_regulars(start_date, end_date, params[:regular])
    end

    if success
      redirect_to new_need_path("regular"), flash: {success: "Planification créée avec succès"}
    else
      respond_to do |format|
        format.html do
          flash.now["error"] = errors
          render :new, status: :unprocessable_entity
        end
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("flash_messages", partial: "layouts/flash", locals: {flash: errors}), status: :unprocessable_entity
        end
      end
    end
  end

  def create_punctual
    @dates = get_dates(params[:punctual][:dates])
    return redirect_to new_need_path("punctual"), flash: {error: "Aucune date valide n'a été fournie"} if @dates.blank?

    intervention = find_or_create_intervention(params[:punctual])
    errors = []

    ActiveRecord::Base.transaction do
      @dates.each do |date|
        planning = Punctual.new(planning_params(:punctual)).tap do |p|
          p.user_id = current_user.id
          p.company_id = Current.company.id
          p.intervention_id = intervention.id
        end

        if planning.save
          create_planning_contacts(planning, params[:punctual])
          punctual_schedules_and_agents(planning, date, params[:punctual][:agents_list])

          unless params[:punctual][:tasks_attributes].nil?
            generate_punctual_tasks(planning, params[:punctual][:tasks_attributes])
          end
        else
          errors.concat(planning.errors.full_messages)
          raise ActiveRecord::Rollback
        end
      end
    end

    if errors.any?
      respond_with_errors(errors)
    else
      redirect_to new_need_path("punctual"), flash: {success: "Planification créée avec succès"}
    end
  end

  def get_interventions
    @model = params[:model]&.downcase
    @contacts = Client.find(params[:id]).contacts.distinct
    @interventions = Client.find(params[:id]).interventions.joins(:address).distinct

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def get_agents
    @agents = Agent.current_company

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/needs/shared/agents_list")
      end
      format.html
    end
  end

  def get_materials
    @materials = Material.current_company

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/needs/shared/materials_list")
      end
      format.html
    end
  end

  private

  def create_single_regular(start_date, end_date, regular_params)
    planning = Regular.new(planning_params("regular"))
    planning.user_id = current_user.id
    planning.company_id = Current.company.id
    intervention_id = regular_params[:intervention_id]

    planning.start_on = start_date
    planning.finish_on = end_date

    if intervention_id.blank? || intervention_id.to_i == -1 && regular_params[:address].present?
      intervention = create_intervention(regular_params)
      planning.intervention_id = intervention.id
    end

    if planning.save
      ActiveRecord::Base.transaction do
        create_planning_contacts(planning, regular_params)
        regular_schedules_and_agents(planning, start_date, end_date, regular_params[:intervention_days] || [], regular_params[:agents_list])
      end
      [true, []]
    else
      [false, planning.errors.full_messages]
    end
  end

  def create_multiple_regulars(start_date, end_date, regular_params)
    split_ranges = split_date_range(start_date, end_date)
    errors = []

    split_ranges.each do |range|
      month_start = range.begin
      month_end = range.end

      mission_params = regular_params.deep_dup
      mission_params[:start_on] = month_start.to_s
      mission_params[:finish_on] = month_end.to_s

      success, mission_errors = create_single_regular(month_start, month_end, mission_params)
      errors.concat(mission_errors) unless success
    end

    [errors.empty?, errors]
  end

  def split_date_range(start_date, end_date)
    slices = []
    current_start = start_date

    while current_start <= end_date
      current_end = [current_start.end_of_month, end_date].min
      slices << (current_start..current_end)
      break if current_end == end_date
      current_start = current_end.next_day.beginning_of_month
    end

    slices
  end

  def get_dates(dates)
    return [] if dates.nil? || dates.empty?

    dates.split(", ").compact.map { |d| Date.parse(d) }
  end

  def find_or_create_intervention(punctual_params)
    if punctual_params[:intervention_id].blank? || punctual_params[:intervention_id].to_i == -1
      return create_intervention(punctual_params) if punctual_params[:address].present?
    end

    Intervention.find(punctual_params[:intervention_id])
  end

  def respond_with_errors(errors)
    respond_to do |format|
      format.html do
        flash.now[:alert] = errors
        render :new, status: :unprocessable_entity
      end
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("flash_messages", partial: "layouts/flash", locals: {flash: errors}), status: :unprocessable_entity
      end
    end
  end

  def create_intervention(planning_params)
    intervention = Intervention.create!(
      client_id: planning_params[:client_id],
      user_id: current_user.id,
      company_id: Current.company.id,
      is_closed: false,
      display_heading: false
    )

    Address.create!(
      street: extract_street(planning_params[:address]),
      postal_code: extract_postal_code(planning_params[:address]),
      city: extract_city(planning_params[:address]),
      country: "France",
      addressable: intervention
    )

    intervention
  end

  def extract_street(full_address)
    full_address.split(",")[0].strip
  rescue
    nil
  end

  def extract_postal_code(full_address)
    full_address.split(",")[-2].strip.match(/\d{5}/).to_s
  rescue
    nil
  end

  def extract_city(full_address)
    full_address.split(",")[-2].strip.gsub(/\d{5}/, "").strip
  rescue
    nil
  end

  def create_planning_contacts(planning, planning_params)
    if planning_params[:"primary-contacts"].present?
      planning_params[:"primary-contacts"].each do |contact_id|
        planning.planning_contacts.create!(contact_id: contact_id, contact_type: "primary")
      end
    end

    if planning_params[:"secondary-contacts"].present?
      planning_params[:"secondary-contacts"].each do |contact_id|
        planning.planning_contacts.create!(contact_id: contact_id, contact_type: "secondary")
      end
    end
  end

  def regular_schedules_and_agents(planning, start_on, finish_on, intervention_days, agents_list_string)
    if params[:regular][:with_tasks].present? && params[:regular][:with_tasks].to_i.zero?
      intervention_days = intervention_days.map(&:to_i)
      agents_list = begin
        JSON.parse(agents_list_string)
      rescue
        []
      end

      (start_on..finish_on).each do |date|
        next if intervention_days.any? && !intervention_days.include?(date.wday)

        schedule = planning.schedules.create!(date: date)
        agents_list.each do |agent_id|
          schedule.planning_agents.create!(agent_id: agent_id)
        end
      end
    else
      generate_tasks(planning, params[:regular][:tasks_attributes])
    end
  end

  def generate_tasks(planning, tasks_attributes)
    tasks_attributes.each do |_index, task_attrs|
        next unless task_attrs[:date].present?

        dates = task_attrs[:date].split(",").map(&:strip).map { |d| Date.parse(d) }

        dates.each do |task_date|
          PlanningTask.create!(
            planning: planning,
            prestation_id: task_attrs[:prestation_id],
            started_at: task_attrs[:started_at],
            finished_at: task_attrs[:finished_at],
            description: CGI.unescapeHTML(task_attrs[:description].to_s),
            date: task_date,
            state: "pending"
          )
        end
      end
  end

  def punctual_schedules_and_agents(planning, date, agents_list_string)
    agents_list = begin
      JSON.parse(agents_list_string)
    rescue
      []
    end

    schedule = planning.build_schedule(date: date)
    agents_list.each do |agent_id|
      schedule.planning_agents.new(agent_id: agent_id)
    end

    schedule.save
  end

  def generate_punctual_tasks(planning, tasks_attributes)
    tasks_attributes.each do |_index, task_attrs|
      task = planning.tasks.build
      task.assign_attributes(task_attrs.permit(:date, :started_at, :finished_at, :prestation_id, :description))
      task.save
    end
  end


  def planning_params(key)
    params.require(key).permit(:client_id, :intervention_id, :prestation_id, :start_on, :finish_on, :agent_needed, :manual_dispatch, :include_vehicle, :needs, :remark, :note, :company_id)
  end
end
