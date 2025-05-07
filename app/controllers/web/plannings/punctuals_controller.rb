class Web::Plannings::PunctualsController < Web::ApplicationController
  before_action :set_punctual, only: [:show, :edit, :update, :destroy]

  def index
    if params[:dates].present?
      dates = parse_dates(params[:dates])

      ids = Schedule.where(date: dates).pluck(:planning_id).uniq
      @punctuals = Punctual.current_company.where(id: ids).includes(:client, :prestation, schedule: :agents, intervention: :address).search(params[:q])
    else
      @punctuals = Punctual.current_company.includes(:client, :prestation, schedule: :agents, intervention: :address).search(params[:q])
    end

    @count = @punctuals.size
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    @punctual.destroy
  end

  private

  def parse_dates(dates)
    dates.split(", ").map { |date| Date.parse(date) }.compact
  end

  def set_punctual
    @punctual = Punctual.find(params[:id])
  end
end
