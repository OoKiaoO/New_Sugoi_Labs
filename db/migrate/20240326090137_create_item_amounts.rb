class CreateItemAmounts < ActiveRecord::Migration[7.1]
  def change
    create_table :item_amounts do |t|
      t.integer :amount
      t.date :exp_date
      t.references :item, null: false, foreign_key: true
      t.boolean :checked
      t.integer :exp_amount

      t.timestamps
    end
  end
end
