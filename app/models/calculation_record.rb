class CalculationRecord < ApplicationRecord
    belongs_to :calculation
    validates :date, presence: true
    validates :rate, presence: true
    validates_associated :calculation

    def self.SaveRecordsForCalculation(todaysRate, infoFromDb, base_amount, calculation)
        records = CalculationGenerationService.generateRecordsArray(todaysRate, infoFromDb, base_amount, calculation)
        records.each do |record|
            if CalculationRecord.create(record)
                else
                    @calculation.CalculationRecords.destroy()
                    @calculation.destroy()
                    flash[:notice] = "Cannot Save Record to Db: " + record
                    redirect_to calculation_new_path
                    break
                end
            end
    end

end
