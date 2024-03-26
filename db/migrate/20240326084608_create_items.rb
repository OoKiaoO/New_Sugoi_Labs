class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.string :name
      t.string :brand
      t.string :barcode
      t.string :secondary_barcode
      t.text :description
      t.decimal :retail
      t.string :category
      t.string :location

      t.timestamps
    end
  end
end
