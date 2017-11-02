class CreateCalculations < ActiveRecord::Migration[5.1]
  def change
    create_table :calculations do |t|

      t.string :base_currency
      t.string :target_currency
      t.integer :period
      t.integer :base_amount
      t.string :date
      t.references :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
