class Web::Settings::EmailModelsController < Web::ApplicationController
  before_action :set_email_model, only: [:update, :edit, :destroy]

  def index
    items = params[:items] || 10
    company_email_models = EmailModel.current_company

    @q = company_email_models.ransack(params[:q])
    @email_models = @q.result.paginate(page: params[:page], per_page: items)
    @count = @email_models.count

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @email_model = EmailModel.new

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/email_models/form", locals: {email_model: @email_model})
      end
    end
  end

  def create
    @email_model = EmailModel.new(email_model_params)

    @email_model.company_id = current_company.id

    if @email_model.save
      respond_to do |format|
        format.html
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "remote_modal",
            partial: "web/settings/email_models/form",
            locals: {email_model: @email_model}
          )
        end
      end
    end
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/email_models/form", locals: {email_model: @email_model})
      end
      format.html
    end
  end

  def update
    if @email_model.update(email_model_params)
      respond_to do |format|
        format.html { redirect_to settings_email_models_path, flash: {success: "Le modèle de courriel a été mis à jour avec succès."} }
        format.turbo_stream { flash.now[:notice] = "Le modèle de courriel a été mis à jour avec succès." }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/email_models/form", locals: {email_model: @email_model}) }
      end
    end
  end

  def destroy
    @email_model.destroy

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_email_model
    @email_model = EmailModel.find(params[:id])
  end

  def email_model_params
    params.require(:email_model).permit(:subject, :body, :company_id)
  end
end
