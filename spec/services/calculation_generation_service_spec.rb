describe CalculationGenerationService do
  api_response = [
    { 'base' => 'USD', 'date' => '2017-11-28', 'rates' => 0.84118 },
    { 'base' => 'USD', 'date' => '2017-11-21', 'rates' => 0.85339 },
    { 'base' => 'USD', 'date' => '2017-11-14', 'rates' => 0.85143 },
    { 'base' => 'USD', 'date' => '2017-11-07', 'rates' => 0.8649 },
    { 'base' => 'USD', 'date' => '2017-10-31', 'rates' => 0.85925 },
    { 'base' => 'USD', 'date' => '2017-10-24', 'rates' => 0.85027 },
    { 'base' => 'USD', 'date' => '2017-10-17', 'rates' => 0.85041 },
    { 'base' => 'USD', 'date' => '2017-10-10', 'rates' => 0.84767 },
    { 'base' => 'USD', 'date' => '2017-10-03', 'rates' => 0.85085 },
    { 'base' => 'USD', 'date' => '2017-08-26', 'rates' => 0.84839 },
    { 'base' => 'USD', 'date' => '2017-09-19', 'rates' => 0.83528 },
    { 'base' => 'USD', 'date' => '2017-09-12', 'rates' => 0.83801 },
    { 'base' => 'USD', 'date' => '2017-09-05', 'rates' => 0.84104 },
    { 'base' => 'USD', 'date' => '2017-08-29', 'rates' => 0.83001 },
    { 'base' => 'USD', 'date' => '2017-08-22', 'rates' => 0.84955 },
    { 'base' => 'USD', 'date' => '2017-08-15', 'rates' => 0.8515 },
    { 'base' => 'USD', 'date' => '2017-08-08', 'rates' => 0.84645 },
    { 'base' => 'USD', 'date' => '2017-08-01', 'rates' => 0.8466 },
    { 'base' => 'USD', 'date' => '2017-07-25', 'rates' => 0.85514 },
    { 'base' => 'USD', 'date' => '2017-07-18', 'rates' => 0.86543 },
    { 'base' => 'USD', 'date' => '2017-07-11', 'rates' => 0.87681 },
    { 'base' => 'USD', 'date' => '2017-07-04', 'rates' => 0.88082 },
    { 'base' => 'USD', 'date' => '2017-06-27', 'rates' => 0.88668 },
    { 'base' => 'USD', 'date' => '2017-06-20', 'rates' => 0.89638 },
    { 'base' => 'USD', 'date' => '2017-06-13', 'rates' => 0.8915 }
  ]
  todays_rates = { 'base' => 'USD', 'date' => '2017-12-05', 'rates' => 0.8441 }
  amount = 2500
  @user = FactoryBot.create(:user)
  context 'self.generateRecordsArray' do
    it 'should generate records array from given arguments' do
      result = CalculationGenerationService.generate_records_array(
        todays_rates,
        api_response,
        amount,
        @user
      )
      expect(result).not_to eql([])
      expect(result[0]).to have_key('rate')
      expect(result[0]).to have_key('date')
    end
  end
  context 'self.moving_average' do
    array_for_calculation = [
      0.8441, 0.84118, 0.85339, 0.85143, 0.8649,
      0.85925, 0.85027, 0.85041, 0.84767, 0.85085, 0.84839,
      0.83528, 0.83801, 0.84104, 0.83001, 0.84955, 0.8515,
      0.84645, 0.8466, 0.85514, 0.86543, 0.87681, 0.88082,
      0.88668, 0.89638, 0.8915, 0.8441
    ]
    it 'should generate moving average on given array and return result' do
      result = CalculationGenerationService.moving_average(
        array_for_calculation,
        26,
        5
      )
      expect(result).not_to eql([])
      expect(result[0]).to eql(0.85589)
    end
  end
  context 'self.generate_and_return_array' do
    it 'should generate generate and return array for calculation' do
      result_array = CalculationGenerationService.generate_and_return_array(
        api_response
      )
      expect(result_array).not_to eql([])
      expect(result_array.length).to eql(api_response.length)
    end
  end
end
