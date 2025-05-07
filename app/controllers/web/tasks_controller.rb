class Web::TasksController < ApplicationController
  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def reorder
    task = Task.find(params[:task_id])
    new_column = ColumnItem.find(params[:column_id])
    position = params[:position]

    Task.transaction do
      if task.column_item_id != new_column.id
        # Update tasks positions in the old column
        task.column_item.tasks.where('position > ?', task.position)
            .update_all('position = position - 1')

        # Update tasks positions in the new column
        new_column.tasks.where('position >= ?', position)
                  .update_all('position = position + 1')

        task.update!(column_item: new_column, position: position)
      else
        # Reordering within the same column
        if task.position < position
          task.column_item.tasks
              .where('position > ? AND position <= ?', task.position, position)
              .update_all('position = position - 1')
        else
          task.column_item.tasks
              .where('position >= ? AND position < ?', position, task.position)
              .update_all('position = position + 1')
        end

        task.update!(position: position)
      end
    end

    head :ok
  end
  private

  def set_task
    @task = Task.find(params[:id])
  end
end
