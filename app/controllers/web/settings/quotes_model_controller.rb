class Web::Settings::QuotesModelController < ApplicationController
  def index
    items = params.fetch(:items, 10).to_i
    @q = Quote.current_company.is_template.includes(:client, :address, :prestation, :contacts, :items).ransack(params[:q])
    @quotes = @q.result
    @quotes = @quotes.paginate(page: params[:page], per_page: items)
    @count = @quotes.count

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end
