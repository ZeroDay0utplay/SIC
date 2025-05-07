class ApplicationController < ActionController::Base
  include Pagy::Backend
  before_action :authenticate_user!
  before_action :set_current_company

  helper_method :current_company

  layout :default_layout

  rescue_from CanCan::AccessDenied do |exception|
    if user_signed_in?
      if current_user.admin?
        redirect_to root_url, alert: exception.message
      elsif !current_user.admin?
        redirect_to root_url, alert: exception.message
      end
    else
      redirect_to root_url, alert: exception.message
    end
  end

  def current_company
    Current.company
  end

  private

  def default_layout
    if current_user&.superadmin? && session[:company_id].blank?
      "superadmin_layout"
    elsif current_user&.superadmin?
      "admin_layout"
    else
      case current_user.try(:type)
      when "Administrator", "Admin"
        "admin_layout"
      when "Technician"
        "application"
      else
        "application"
      end
    end
  end

  def set_current_company
    return unless user_signed_in?

    Current.company = if current_user.superadmin?
      Company.find_by(id: session[:company_id] || params[:company_id])
    else
      Current.company = current_user.company
    end

    session[:company_id] = Current.company.id if Current.company && current_user.superadmin?
  end
end
