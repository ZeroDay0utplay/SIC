module ChecksCompany
  extend ActiveSupport::Concern

  included do
    before_action :check_company
  end

  private

  def check_company
    return if current_user&.company.present? || session[:company_id].present?

    respond_to do |format|
      format.html do
        redirect_to root_path, flash: {
          danger: "Pour accéder à cette page, il est nécessaire d'avoir une entreprise."
        }
      end
    end
  end
end
