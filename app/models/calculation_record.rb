class CalculationRecord < ApplicationRecord
    belongs_to :calculation
    validates :date, presence: true
    validates :rate, presence: true
    validates_associated :calculation
    dependent: :destroy

    def self.SaveRecordsForCalculation(todaysRate, infoFromDb, base_amount, calculation)
        records = CalculationGenerationService.generateRecordsArray(todaysRate, infoFromDb, base_amount, calculation)
        records.each do |record|
            if CalculationRecord.create(record)

                else
                    @calculation.destroy()
                    flash[:notice] = "Cannot Save Record to Db: " + record
                    return false
                    break

                end
        end
        
    end

end