class Web::Settings::PrestationsController < Web::ApplicationController
  before_action :set_prestation, only: [:update, :edit, :destroy]

  def index
    items = params[:items] || 10
    @q = Prestation.current_company.order(:created_at).ransack(params[:q])

    @prestations = if params[:type_prestation].present?
      @q.result.where(type_prestation: params[:type_prestation]).paginate(page: params[:page], per_page: items)
    else
      @q.result.paginate(page: params[:page], per_page: items)
    end

    @count = @prestations.count

    respond_to do |format|
      format.html
      format.json { render json: Prestation.current_company.select(:id, :name) }
      format.turbo_stream
    end
  end

  def new
    @prestation = Prestation.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/prestations/form", locals: {prestation: @prestation})
      end
      format.html
    end
  end

  def modal_new
    @prestation = Prestation.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/shared/modals/new_prestation_modal", locals: {prestation: @prestation})
      end
      format.html
    end
  end

  def create
    @prestation = Prestation.new(prestation_params)
    @prestation.company_id = current_user.company.id
    respond_to do |format|
      if @prestation.save
        format.html { redirect_to settings_prestations_path, flash: {success: "Prestation crée avec succès"} }
        format.turbo_stream do
          FlashMessageService.new(self).call(:success, "Prestation crée avec succès")
        end
      else
        format.turbo_stream do
          FlashMessageService.new(self).call(:danger, "Le type de prestation doit être unique")
        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/prestations/form", locals: {prestation: @prestation})
      end
      format.html
    end
  end

  def update
    @prestation.company_id = current_user.company.id
    if @prestation.update(prestation_params)
      respond_to do |format|
        format.html { redirect_to settings_prestations_path, flash: {success: "Prestation modifiée avec succès"} }
        format.turbo_stream { flash.now[:notice] = "Prestation was successfully updated." }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/prestations/form", locals: {prestation: @prestation}) }
      end
    end
  end

  def destroy
    @prestation.destroy

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_prestation
    @prestation = Prestation.find(params[:id])
  end

  def prestation_params
    params.require(:prestation).permit(:name, :description, :alias, :price, :remark, :unity, :type_prestation, :state, :company_id)
  end
end
