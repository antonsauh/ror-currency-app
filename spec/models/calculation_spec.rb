require 'rails_helper'

RSpec.describe Calculation, type: :model do
    context 'valid Factory' do
        it 'has a valid factory' do
        expect(FactoryBot.build(:calculation)).to be_valid
        end
    end

    context 'Has a valid association' do
        it { should have_many(:calculation_records) }
        it { should belong_to(:user) }
    end

    before :each do
        @calculation = FactoryBot.build(:calculation)
        @calculation_record = FactoryBot.build(:calculation_record, calculation_id: @calculation.id)
    end

    context 'Validates data presence' do
        it 'Is a valid calculation' do
            expect(@calculation).to be_valid
        end

        it 'Validates presence of base_currency' do
            @calculation.base_currency = nil
            expect(@calculation).to_not be_valid
        end

        it 'Validates presence of target_currency' do
            @calculation.target_currency = nil
            expect(@calculation).to_not be_valid
        end    

        it 'Validates presence of period' do
            @calculation.period = nil
            expect(@calculation).to_not be_valid
        end

        it 'Validates presence of base_amount' do
            @calculation.base_amount = nil
            expect(@calculation).to_not be_valid
        end

        it 'Validates presence of date' do
            @calculation.date = nil
            expect(@calculation).to_not be_valid
        end
    end

  end