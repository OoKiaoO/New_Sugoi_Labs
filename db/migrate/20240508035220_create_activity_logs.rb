class CreateActivityLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_logs do |t|
      t.references :item, null: false, foreign_key: true
      t.string :action
      t.string :item_amount
      t.date :item_amount_exp_date

      t.timestamps
    end
  end
end
