class CalculationGenerationService
#  generates array with predicted rates and sums and also cleans up 
#  the passed object to be ready for record creation process.
    def self.generateRecordsArray(todaysRates, array, amount, calculation_data)
        rateSum = 0
        iterations = 1
        date = 
        todayRate = todaysRates['rates']
        date = Date.parse(todaysRates['date']) + 7
        array.each do | item |
            rate = item['rates']
            rateSum += rate
            item['rate'] = (rate * (todayRate.to_f / (rateSum.to_f / iterations.to_f))).round(6)
            item['date'] = date
            item['total'] = (amount * item['rate']).round(2)
            item['calculation'] = calculation_data
            iterations = iterations + 1
            date = date + 7
            item.delete("base")
            item.delete("rates")
        end
        return array
    end

end