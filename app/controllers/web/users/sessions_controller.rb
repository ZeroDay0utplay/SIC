class Web::Users::SessionsController < Devise::SessionsController
  skip_around_action :authenticate_user!, raise: false, only: :create

  def new
    @user = User.new
  end

  def create
    session[:company_id] = nil
    @user = User.find_by(email: user_params[:email])

    if warden.authenticate?(scope: :user)
      if @user.active? && ["Superadmin", "Admin", "Subcontractor"].include?(@user&.type)
        sign_in(:user, @user)
        redirect_to after_sign_in_path_for(@user), flash: {success: "Vous êtes connecté."}
      else
        sign_out(@user)
        redirect_to new_user_session_path, flash: {success: "Utilisateur archivé ou non autorisé."}
      end
    else
      reset_session
      redirect_to new_user_session_path, flash: {success: "Ces identifiants ne sont pas corrects."}
    end
  end

  def destroy
    session[:company_id] = nil
    sign_out(current_user)
    redirect_to new_user_session_path, flash: {error: "Vous avez réussi à vous déconnecter."}
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :remember_me)
  end
end
