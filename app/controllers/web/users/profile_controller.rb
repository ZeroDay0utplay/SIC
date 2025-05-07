class Web::Users::ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def edit
    @user = User.find(current_user.id)
    render "devise/profile/edit"
  end

  def update
    @user = User.find(current_user.id)
    if @user.update(user_params)
      redirect_to root_path, flash: {success: "Le profil a été mis à jour avec succès!"}
    else
      render "devise/profile/edit"
    end
  end

  private

  def user_params
    user_type = params.keys.find { |key| key.to_s.downcase.in?(%w[admin superadmin]) }
    params.require(user_type).permit(:first_name, :last_name, :phone, :email, :photo)
  end
end
