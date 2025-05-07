class Api::V1::ApplicationController < ::ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :authenticate_user!

  private

  def authenticate_user!
    token = params[:authentication_token] || request.headers["Authorization"]&.split(" ")&.last

    if token
      @current_user = User.find_by(authentication_token: token)
      if @current_user
        true
      else
        render json: {error: "Unauthorized"}, status: :unauthorized
      end
    else
      render json: {error: "Unauthorized"}, status: :unauthorized
    end
  end

  attr_reader :current_user
end
