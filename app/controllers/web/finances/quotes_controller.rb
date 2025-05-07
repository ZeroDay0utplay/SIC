class Web::Finances::QuotesController < Web::Finances::CommercialsController
  before_action :set_quote, only: [:edit, :update, :edit_informations, :update_informations, :edit_prestations, :update_prestations, :preview, :pdf]

  def index
    items = params.fetch(:items, 10).to_i
    @q = Quote.current_company.is_not_template.includes(:client, :address, :prestation, :contacts, :items).order(created_at: :desc).ransack(params[:q])
    @quotes = @q.result
    @quotes = @quotes.by_state(params[:state]) if params[:state].present?

    if params[:creation_dates].present?
      selected_months = CGI.unescape(params[:creation_dates]).split(",")
      @quotes = @quotes.by_creation_dates(selected_months)
    end

    @quotes = @quotes.paginate(page: params[:page], per_page: items)
    @count = @quotes.count

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def edit
  end

  def new
    @quote = Quote.new
    @quote.build_address
    @quote.build_payment_method
    @quote.build_commercial_detail
    @quote.reference = @quote.generate_reference
  end

  def new_from_model
    @quote = Quote.find_by(id: params[:source_id])
    @new_quote = @quote.dup
    @new_quote.reference = @new_quote.generate_reference
    @new_quote.commercial_detail = @quote.commercial_detail.dup
    @new_quote.payment_method = @quote.payment_method.dup
    @new_quote.items = @quote.items.map do |item|
      item.dup
    end
    @new_quote.address = @quote.address.dup
    @new_quote.is_template = false
    @new_quote.template_name = nil

    if @new_quote.save
      redirect_to edit_finances_quote_path(@new_quote.id)
    else
      redirect_to finances_quotes_path, flash: {error: ""}
    end
  end

  def create_quote_contact
    ActiveRecord::Base.transaction do
      quote_id = params[:contact][:quote_id]
      @quote = Quote.find(quote_id)
      client_id = @quote.client.id
      @contact = Contact.new(contact_params)
      @contact.company_id = current_user.company.id
      @contact.clients << Client.where(id: client_id)
      @contact.save!
      CommercialContact.create!(commercial_id: quote_id, contact_id: @contact.id)
      render turbo_stream: [
        FlashMessageService.new(self).build_stream(:success, "Contact créé avec succès"),
        turbo_stream.replace("contacts_list", partial: "web/shared/contacts_list", locals: {contacts: @quote.client.contacts, model: @quote.class.name.downcase, type: "primary", selected: @quote.contacts.ids})
      ]
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  rescue ActiveRecord::RecordInvalid => e
    render turbo_stream: FlashMessageService.new(self).build_stream(:danger, "Une erreur s'est produite : #{e.message}")
  end

  def create
    @quote = Quote.new(quote_params)
    @quote.company_id = current_user.company.id
    @quote.created_by = current_user.id

    if @quote.save
      redirect_to edit_informations_finances_quote_path(@quote.id)
    else
      render :new
    end
  end

  def update
    if @quote.update(quote_params)
      redirect_to edit_informations_finances_quote_path(@quote.id)
    else
      render :edit
    end
  end

  def destroy
    @quote = Quote.find_by(id: params[:id])
    # TO DO: Toast notification
    if @quote&.destroy
      respond_to do |format|
        format.turbo_stream { FlashMessageService.new(self).build_stream(:success, "Devis supprimé avec succès") }
      end
    else
      render turbo_stream: FlashMessageService.new(self).build_stream(:danger, "Une erreur s'est produite")
    end
  end

  def edit_informations
    @quote = Quote.find_by(id: params[:id])
    render :edit_informations
  end

  def update_informations
    address = params[:quote][:address] || []
    intervention_id = params[:quote][:intervention_id] || []
    contact_ids = params[:quote]["primary-contacts"] || []

    ActiveRecord::Base.transaction do
      contact_ids.each do |contact_id|
        CommercialContact.find_or_create_by!(commercial_id: @quote.id, contact_id: contact_id)
      end

      if intervention_id.blank? || intervention_id.to_i == -1
        params[:quote].delete(:intervention_id)
        intervention = create_intervention(address)
        @quote.intervention_id = intervention.id
      end

      @quote.commercial_contacts.where.not(contact_id: contact_ids).destroy_all
      @quote.update(quote_params)
    end
    redirect_to edit_prestations_finances_quote_path(@quote.id), flash: {success: "Information ajouté avec succès"}
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Une erreur s'est produite : #{e.message}"
    redirect_back(fallback_location: edit_informations_finances_quote_path(@quote.id))
  end

  def create_intervention(address)
    result = Geocoder.search(address).first&.data || []

    new_address = if result.empty?
      []
    else
      result["address"]
    end

    intervention = Intervention.create!(
      client_id: @quote.client.id,
      user_id: current_user.id,
      company_id: Current.company.id,
      is_closed: false,
      display_heading: false
    )

    if new_address.empty?
      Address.create!(
        entered_by_user: address,
        addressable: intervention
      )
    else
      Address.create!(
        street: new_address["street"] || new_address["road"],
        postal_code: new_address["postcode"] || new_address["postal_code"],
        city: new_address["city"] || new_address["village"] || new_address["town"] || new_address["municipality"],
        country: "France",
        latitude: result["lat"] || nil,
        longitude: result["lon"] || nil,
        entered_by_user: address,
        addressable: intervention
      )
    end

    intervention
  end

  def edit_prestations
    render :edit_prestations
  end

  def update_prestations
    message = ""
    ActiveRecord::Base.transaction do
      result = @quote.update!(quote_params)
      if result
        message = "Devis enregistré avec succès"
        if @quote.template_id.nil?
          if use_as_template(@quote) && params[:quote][:use_as_template].to_i == 1
            message = "Devis et la template enregistrés avec succès"
          end
        end
      end
    end
    redirect_to finances_quotes_path, flash: {success: message}
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = "Une erreur s'est produite : #{e.message}"
    redirect_back(fallback_location: edit_prestations_finances_quote_path(@quote.id))
  end

  def client_headings
    @client = Client.find_by(id: params[:id])
    @headings = @client.headings
    @formatted_headings = @headings.map { |h| {id: h.id, name: h.title} }

    respond_to do |format|
      format.turbo_stream
      format.json { render json: @formatted_headings }
    end
  end

  def admin_details
    @admin = Admin.current_company.find_by(id: params[:id])

    respond_to do |format|
      format.turbo_stream
    end
  end

  def preview
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/finances/quotes/modal_pdf", locals: {quote: @quote})
      end
      format.html
    end
  end

  def pdf
    @company = Current.company
    respond_to do |format|
      format.pdf do
        response.headers["Content-Type"] = "application/pdf"
        render pdf: "Devis #{@quote.reference}",
          template: "web/finances/quotes/pdf",
          formats: [:html],
          header: {content: ""},
          footer: {content: ""}
      end
    end
  end

  def use_as_template(quote)
    # TODO: convert quote to template and duplicate only last step quote with items
    template_name = params[:quote][:template_name] || ""
    quote_model = quote.dup
    quote_model.is_template = true
    quote_model.template_name = template_name

    quote_model.commercial_detail = quote.commercial_detail.dup
    quote_model.payment_method = quote.payment_method.dup
    quote_model.address = quote.address.dup
    quote_model.items = quote.items.map do |item|
      item.dup
    end

    if quote_model.save!
      quote.update!(template_id: quote_model.id)
    else
      false
    end
  end

  private

  private

  def set_quote
    @quote = Quote.find_by(id: params[:id])
    @quote.build_address if @quote&.address.nil?
    @quote.build_commercial_detail if @quote&.commercial_detail.nil?
    @quote.build_payment_method if @quote&.payment_method.nil?
  end

  def quote_params
    params.require(:quote).permit(
      :user_id, :client_id, :heading_id, :prestation_id, :reference, :validate_date, :signed_before, :must_signed, :photo, :intervention_id, :reduction_unit, :reduction, :document_title, :description, :use_as_template,
      items_attributes: [:id, :prestation_id, :unit_price, :quantity, :unit, :days, :order, :description, :has_description, :has_reduction, :reduction_unit, :reduction, :_destroy],

      payment_method_attributes: [:id, :commercial_id, :deadline_regle, :delai_regle, :discount_type, :payment_mode, :bank_transfer_reference, :paid_amount, :paid_amount_date, :payment_status],

      commercial_detail_attributes: [:id, :commercial_id, :display_unit_count, :display_description, :display_empty_fields, :display_footer, :display_global_discount, :display_discount, :display_heading, :display_legal_mentions, :display_amount_before_tax, :display_days_column, :display_days, :display_service_details, :display_quantity, :display_reference, :display_title, :display_total_with_tax],

      address_attributes: [:id, :street, :complement, :postal_code, :city, :country, :entered_by_user, :latitude, :longitude, :geocoder_value, :zoom, :addressable_type, :addressable_id]
    )
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :phone, :email, :company_name, :job, :role, client_ids: [])
  end
end
