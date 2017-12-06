require 'rails_helper'

RSpec.describe CalculationRecord, type: :model do
  context 'valid FactoryBot data' do
    it 'has a valid data built by FactoryBot' do
      expect(FactoryBot.build(:calculation_record)).to be_valid
    end
  end

  before :each do
    @calculation = FactoryBot.build(:calculation)
    @calculation_record = FactoryBot.build(:calculation_record, calculation_id: @calculation.id)
  end

  context 'controls the data presence' do
    it 'should not be valid without rate' do
      @calculation_record.rate = nil
      expect(@calculation_record).to_not be_valid
    end

    it 'should not be valid without date' do
      @calculation_record.date = nil
      expect(@calculation_record).to_not be_valid
    end
  end
end
