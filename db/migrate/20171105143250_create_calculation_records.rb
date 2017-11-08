class CreateCalculationRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :calculation_records do |t|
      t.references :calculation, index: true, foreign_key: true
      t.date :date
      t.float :rate
      t.float :total

      t.timestamps
    end
  end
end
