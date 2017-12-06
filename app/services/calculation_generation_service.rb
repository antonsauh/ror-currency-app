# Calculation Generation Service
class CalculationGenerationService
    #  generates array with predicted rates and sums and also cleans up.
    #  the passed object to be ready for record creation process.
    def self.generateRecordsArray(todaysRates, array, amount, calculation_data)
      date = Date.parse(todaysRates['date']) + 7
      arrayForCalculation = generate_and_return_array(array) << todaysRates['rates'].to_f
        i = 1
        array.each do | item |
            item['rate'] = moving_average(arrayForCalculation, 26, 5)[0]
            arrayForCalculation = arrayForCalculation.slice(1..26)
            arrayForCalculation << item['rate']
            item['total'] = item['rate'] * amount
            item['date'] = date
            item['calculation'] = calculation_data
            date = date + 7
            item.delete('base')
            item.delete('rates')
            i = i + 1
        end
            array
    end

    def self.moving_average(a, ndays, precision)
      a.each_cons(ndays).map { |e| e.reduce(&:+).fdiv(ndays).round(precision) }
    end

    def self.generate_and_return_array(object)
      my_array = []
      object.each do |item|
        my_array << item['rates'].to_f
      end
      my_array
    end
end
