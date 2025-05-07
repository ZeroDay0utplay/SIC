class AddCompanyIdToUser < ActiveRecord::Migration[7.1]
  def up
    add_reference :users, :company, null: true, foreign_key: true
  end
end
