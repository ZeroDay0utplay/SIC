class Api::V1::SessionsController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:create]
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  # POST /api/v1/sessions
  def create
    user = User.find_by(email: params[:email])
    if user&.valid_password?(params[:password])
      user.update(authentication_token: SecureRandom.hex(20))
      render json: {authentication_token: user.authentication_token, user: UserSerializer.new(user)}, status: :ok
    else
      render json: {error: "Invalid email or password"}, status: :unauthorized
    end
  end

  # DELETE /api/v1/sessions
  def destroy
    if current_user
      current_user.update(authentication_token: nil)
      render json: {message: "Signed out successfully"}, status: :ok
    else
      render json: {error: "Unauthorized"}, status: :unauthorized
    end
  end
end
