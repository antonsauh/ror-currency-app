class ChangeDataTypeForRecordTotalAndRate < ActiveRecord::Migration[5.1]
  def change
    change_column :calculation_records, :rate, :decimal
    change_column :calculation_records, :total, :decimal
  end
end
