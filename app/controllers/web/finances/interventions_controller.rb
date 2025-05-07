class Web::Finances::InterventionsController < Web::ApplicationController
  before_action :set_intervention, only: %i[show destroy]
  def index
    items = params.fetch(:items, 10).to_i

    if params[:selected_months].present?
      CGI.unescape(params[:selectedMonths]).split(",")
    end

    @years = Intervention.current_company.pluck(:created_at).map(&:year).uniq

    @interventions = Intervention
      .includes(:client, :address, :heading, :admin)
      .search(params[:search])
      .distinct
      .order(created_at: :desc)
      .paginate(page: params[:page], per_page: items)

    @count = @interventions.count

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
  end

  def destroy
  end

  private

  def set_intervention
    @intervention = Intervention.find(params[:id])
  end
end
