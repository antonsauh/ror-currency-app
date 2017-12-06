# Calculation Record Model
class CalculationRecord < ApplicationRecord
  belongs_to :calculation
  validates :date, presence: true
  validates :rate, presence: true
  validates_associated :calculation

  def self.save_records_for_calculation(todays_rate, info_from_db, base_amount, calculation)
    records = CalculationGenerationService.generate_records_array(todays_rate, info_from_db, base_amount, calculation)
    records.each do |record|
      if CalculationRecord.create(record)

      else
              @calculation.destroy
              flash[:notice] = 'Cannot Save Record to Db: ' + record
              return false

      end
    end
  end
end
