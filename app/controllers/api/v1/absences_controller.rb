class Api::V1::AbsencesController < Api::V1::BaseController
  before_action :authenticate_user!

  def index
    absences = current_user.absences
    render json: absences, status: :ok
  end
end
