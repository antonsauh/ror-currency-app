class AddRateToCalculation < ActiveRecord::Migration[5.1]
  def change
    add_column :calculations, :rate, :float
  end
end
