# Calculation Generation Service
class CalculationGenerationService
  #  generates array with predicted rates and sums and also cleans up.
  #  the passed object to be ready for record creation process.
  def self.generate_records_array(todays_rates, array, amount, calculation_data)
    date = Date.parse(todays_rates['date']) + 7
    array_for_calculation = generate_and_return_array(array) << todays_rates['rates'].to_f
    i = 1
    array.each do |item|
      item['rate'] = moving_average(array_for_calculation, 26, 5)[0]
      array_for_calculation = array_for_calculation.slice(1..26)
      array_for_calculation << item['rate']
      item['total'] = item['rate'] * amount
      item['date'] = date
      item['calculation'] = calculation_data
      date += 7
      item.delete('base')
      item.delete('rates')
      i += 1
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
