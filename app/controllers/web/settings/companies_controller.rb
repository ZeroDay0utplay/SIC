class Web::Settings::CompaniesController < Web::ApplicationController
  before_action :set_company
  before_action :can_own_admin?

  def edit
    @company.build_address if @company.address.nil?
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("edit-company", partial: "web/settings/companies/edit_company_confirme", locals: {company: @company}) }
        format.html { redirect_to settings_company_path, flash: {success: "La société a été mise à jour avec succès."} }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("edit-company", partial: "web/settings/companies/form_edit", locals: {company: @company}) }
        format.html { render :edit }
      end
    end
  end

  def update_bank
    respond_to do |format|
      if @company.update(company_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("edit-bank", partial: "web/settings/companies/edit_bank_confirme", locals: {company: @company}) }
        format.html { redirect_to settings_company_path, flash: {success: "La société a été mise à jour avec succès."} }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("edit-bank", partial: "web/settings/companies/form_bank", locals: {company: @company}) }
        format.html { render :edit }
      end
    end
  end

  def numberings
  end

  def update_numberings
    respond_to do |format|
      if @company.update(company_params)
        format.turbo_stream { render turbo_stream: turbo_stream.replace("edit-numbering", partial: "web/settings/companies/edit_numbering_confirme", locals: {company: @company}) }
        format.html { redirect_to settings_company_path, flash: {success: "La société a été mise à jour avec succès."} }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.replace("edit-numbering", partial: "web/settings/companies/form_numbering", locals: {company: @company}) }
        format.html { render :edit }
      end
    end
  end

  def bank
  end

  def show
  end

  def destroy
  end

  private

  def can_own_admin?
    return if current_user.company.subdomain == @company.subdomain

    redirect_to edit_settings_company_path(current_user.company.id), allow_other_host: true
  end

  def set_company
    @company = Company.find_by(id: params[:id])
  end

  def company_params
    params.require(:company).permit(:social_reason, :email, :tel, :establishment, :taux_tva,
      :iban, :bic, :prefix_bill, :prefix_quote, :prefix_credit, :footer_page, :logo, address_attributes: [:id, :street, :complement, :postal_code, :city, :country, :entered_by_user])
  end
end
