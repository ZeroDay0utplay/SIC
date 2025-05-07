class Web::Finances::CommercialsController < Web::ApplicationController
  def get_prestations
    @prestations = Prestation.current_company.all

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("remote_modal", partial: "web/finances/quotes/form_catalogue")
      end
      format.html
    end
  end

  def set_prestation
    @prestation = Prestation.find_by(id: params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.append("items-container", partial: "web/finances/quotes/item_template")
      end
      format.html
    end
  end
end
