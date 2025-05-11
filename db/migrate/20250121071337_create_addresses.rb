class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :street
      t.string :complement
      t.string :postal_code
      t.string :city
      t.string :country, default: "Tunisia"
      t.string :entered_by_user
      t.float :latitude
      t.float :longitude
      t.jsonb :geocoder_value, default: {}
      t.integer :zoom

      t.references :addressable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
