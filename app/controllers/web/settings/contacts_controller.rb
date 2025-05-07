class Web::Settings::ContactsController < Web::ApplicationController
  before_action :set_contact, only: [:update, :edit, :destroy]
  before_action :set_contact_details, only: [:new, :edit]

  def index
    items = params[:items] || 10

    company_contacts = Contact.current_company.includes(:clients)

    @q = company_contacts.ransack(params[:q])
    @contacts = @q.result.paginate(page: params[:page], per_page: items)
    @count = @q.result.count

    respond_to do |format|
      format.html
      format.json { render json: company_contacts.map { |contact| {id: contact.id, name: contact&.full_name} } }
      format.turbo_stream
    end
  end

  def new
    @contact = Contact.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/contacts/form", locals: {contact: @contact})
      end
      format.html
    end
  end

  def modal_new
    @contact = Contact.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/shared/modals/new_contact_modal", locals: {contact: @contact})
      end
      format.html
    end
  end

  def create
    @contact = Contact.new(contact_params)
    @contact.company_id = current_user.company.id
    @contact.clients << Client.where(id: params[:contact][:client_id])
    if @contact.save
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    end
  end

  def search
    @contacts = Contact.where("name ILIKE ?", "%#{params[:query]}%")
    respond_to do |format|
      format.turbo_stream
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/contacts/form", locals: {contact: @contact})
      end
      format.html
    end
  end

  def update
    if @contact.update(contact_params)
      respond_to do |format|
        format.html { redirect_to settings_contacts_path, flash: {success: "Contact a été mis à jour."} }
        format.turbo_stream { FlashMessageService.new(self).call(:success, "Contact a été mis à jour.") }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { FlashMessageService.new(self).call(:danger, "Une erreur s'est produite") }
      end
    end
  end

  def destroy
    @contact.destroy

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_contact_details
    @contacts = Contact.current_company
    @clients = Client.current_company
    @companies = @contacts.pluck(:company_name).reject { |name| name.empty? }
    @jobs = @contacts.pluck(:job).reject { |name| name.empty? }
  end

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:first_name, :last_name, :phone, :email, :company_name, :job, :role, client_ids: [])
  end
end
