class Web::BoardsController < ApplicationController
  before_action :set_board, only: [:show, :update, :edit, :destroy]
  def index
    @boards = Board.current_company

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @column_items = @board.column_items.includes(tasks: [:user])

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def new
    @board = Board.new

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/boards/form", locals: {board: @board})
      end
    end
  end

  def create
    @board = Board.new(board_params)
    @board.company_id = current_company.id

    if @board.save
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
            partial: "web/boards/form",
            locals: { board: @board }
          )
        end
      end
    end
  end


  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/boards/form", locals: {board: @board})
      end
      format.html
    end
  end

  def update
    if @board.update(board_params)
      respond_to do |format|
        format.html { redirect_to boards_path, flash: {success: "Le board a été mis à jour avec succès."} }
        format.turbo_stream { flash.now[:notice] = "Le board a été mis à jour avec succès." }
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("remote_modal", partial: "web/boards/form", locals: {board: @board}) }
      end
    end
  end

  def destroy
    @board.destroy

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_board
    @board = Board.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :order, :company_id)
  end
end
