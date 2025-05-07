class Web::Settings::HeadingsController < Web::ApplicationController
  def modal_new
    @heading = Heading.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/shared/modals/new_heading_modal", locals: {heading: @heading})
      end
      format.html
    end
  end

  def create
    @heading = Heading.new(heading_params)
    respond_to do |format|
      if @heading.save!
        format.turbo_stream do
          FlashMessageService.new(self).call(:success, "Intitulé crée avec succès")
        end
      else
        format.turbo_stream do
          FlashMessageService.new(self).call(:danger, "Une erreur s'est produite")
        end
      end
    end
  end

  def set_heading
    @heading = Heading.find(params[:id])
  end

  def heading_params
    params.require(:heading).permit(
      :title,
      :description,
      :client_id
    )
  end
end
