class Web::ApplicationController < ApplicationController
  include ChecksCompany
  before_action :authorize_access

  layout "admin_layout"

  private

  def authorize_access
    unless current_user&.superadmin? || current_user&.admin?
      flash[:danger] = "Accès refusé."
      redirect_to root_path
    end
  end
end
