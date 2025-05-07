class Web::AbsencesController < Web::ApplicationController
  include ChecksCompany

  before_action :set_absence, only: [:update, :edit, :destroy]

  def index
    items = params[:items] || 10
    @q = Absence.joins(:user).ransack(params[:q])

    @absences = if params[:state].present?
      @q.result.where(state: params[:state]).paginate(page: params[:page], per_page: items)
    else
      @q.result.paginate(page: params[:page], per_page: items)
    end

    @count = @absences.count

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @absence = Absence.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/absences/form", locals: {absence: @absence})
      end
      format.html
    end
  end

  def create
    @absence = Absence.new(absence_params)

    if @absence.save
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/absences/form", locals: {absence: @absence})
      end
      format.html
    end
  end

  def update
    if @absence.update(absence_params)
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/absences/form", locals: {absence: @absence}) }
      end
    end
  end

  def destroy
    if @absence.destroy
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end

  private

  def set_absence
    @absence = Absence.find(params[:id])
  end

  def absence_params
    params.require(:absence).permit(:date_start, :date_end, :motif, :type_absence, :user_id, :state, :docuemnt, :state)
  end
end
