class Web::Settings::ClientsController < Web::ApplicationController
  before_action :get_client, only: [:edit, :update, :destroy]

  def index
    items = params[:items] || 10
    @q = Client.includes(:address).current_company.with_attached_logo.ransack(params[:q])
    @clients = @q.result.paginate(page: params[:page], per_page: items)

    @count = @clients.count

    respond_to do |format|
      format.html
      format.json { render json: Client.current_company.select(:id, :name) }
      format.turbo_stream
    end
  end

  def new
    @client = Client.new
    @client.build_address
  end

  def modal_new
    @client = Client.new
    @client.build_address

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/shared/modals/new_client_modal", locals: {client: @client})
      end
      format.html
    end
  end

  def create
    @url = settings_clients_path
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html { redirect_to @url }
        format.turbo_stream do
          FlashMessageService.new(self).call(:success, "Client créé avec succès")
        end
      else
        format.turbo_stream do
          FlashMessageService.new(self).call(:danger, "Une erreur s'est produite")
        end
      end
    end
  end

  def edit
    @client.build_address unless @client.address.present?
  end

  def update
    @url = settings_clients_path

    if @client.update(client_params)
      respond_to do |format|
        format.html { redirect_to @url }
        format.turbo_stream
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @client.destroy

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def get_client
    @client = Client.find(params[:id])
  end

  def client_params
    params.require(:client).permit(:reference, :name, :email, :client_type, :logo, :role, address_attributes: [:street, :country, :city, :postal_code])
  end
end
