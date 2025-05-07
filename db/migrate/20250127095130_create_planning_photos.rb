class CreatePlanningPhotos < ActiveRecord::Migration[8.0]
  def change
    create_table :planning_photos do |t|
      t.references :imageable, polymorphic: true, null: false
      t.integer :photo_type
      t.integer :before_after
      t.bigint :linked_photo_id, null: true

      t.timestamps
    end

    add_index :planning_photos, :linked_photo_id
  end
end
