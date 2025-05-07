class Web::Settings::MentionLegalsController < Web::ApplicationController
  before_action :set_mention_legal, only: [:show, :update, :destroy]

  def index
    items = params[:items] || 10
    @q = MentionLegal.order(created_at: :desc).ransack(params[:q])
    @mention_legals = @q.result.paginate(page: params[:page], per_page: items)

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("cover-mention-legals", partial: "web/settings/mention_legals/mention_legals", locals: {mention_legals: @mention_legals, pagy: @pagy})
      end
      format.html
    end
  end

  def new
    @mention_legal = MentionLegal.new
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/mention_legals/new_mention_legal_modal", locals: {mention_legal: @mention_legal})
      end
      format.html
    end
  end

  def edit
    @mention_legal = MentionLegal.find(params[:id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/mention_legals/edit_mention_legal_modal", locals: {mention_legal: @mention_legal})
      end
      format.html
    end
  end

  def create
    @mention_legal = MentionLegal.new(mention_legal_params)
    if @mention_legal.save
      respond_to do |format|
        format.turbo_stream do
          format.html { redirect_to settings_mention_legals_path, flash: {success: "La mention a été créée avec succès."} }
          render turbo_stream: turbo_stream.replace("mention_legal_search", partial: "web/settings/companies/edit_mention_confirme")
        end
        format.html
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/settings/mention_legals/new_mention_legal_modal", locals: {mention_legal: @mention_legal})
        end
        format.html { render :new }
      end
    end
  end

  def update
    if @mention_legal.update(mention_legal_params)
      respond_to do |format|
        format.html { redirect_to settings_mention_legals_path, flash: {success: "Mention mise à jour avec succès."} }
        format.turbo_stream { flash.now[:notice] = "Mention was successfully updated." }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@mention_legal, partial: "web/settings/mention_legals/edit_mention_legal_modal", locals: {mention_legal: @mention_legal}) }
      end
    end
  end

  def destroy
    @mention_legal.destroy
    respond_to do |format|
      format.html { redirect_to settings_mention_legals_path, flash: {success: "Mention supprimée avec succès."} }
      format.turbo_stream
    end
  end

  def mention_legal
    @mention_legal = MentionLegal.all
  end

  private

  def set_mention_legal
    @mention_legal = MentionLegal.find(params[:id])
  end

  def mention_legal_params
    params.require(:mention_legal).permit(:name, :description)
  end
end
