FactoryBot.define do
  factory :calculation do
    base_currency 'EUR'
    target_currency 'USD'
    period 3
    base_amount 1000
    date '01-01-2017'
    user
  end
end
