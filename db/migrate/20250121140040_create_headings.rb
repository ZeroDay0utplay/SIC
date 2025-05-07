class CreateHeadings < ActiveRecord::Migration[8.0]
  def change
    create_table :headings do |t|
      t.string :title
      t.text :description
      t.bigint :client_id
      t.timestamps
    end
  end
end
