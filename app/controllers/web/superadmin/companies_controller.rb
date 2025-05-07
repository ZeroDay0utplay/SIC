class Web::Superadmin::CompaniesController < ApplicationController
  load_and_authorize_resource

  def index
    @companies = Company.all
  end

  def switch_company
    company = Company.find_by(id: params[:id])

    if company
      session[:company_id] = company.id
      redirect_to root_path, flash: {success: "Agence actuelle #{company.social_reason}"}
    else
      redirect_to superadmin_companies_path, flash: {error: "Agence non trouvée"}
    end
  end

  def switch_global
    session.delete(:company_id)
    redirect_to companies_path
  end
end
