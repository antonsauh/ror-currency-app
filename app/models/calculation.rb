class Calculation < ApplicationRecord
    belongs_to :user
    validates :base_currency, presence: true
    validates :target_currency, presence: true
    validates :period, presence: true
    validates :base_amount, presence: true
    validates :date, presence: true
    validates :base_currency, presence: true
    validates_associated :user
    has_many :calculation_records, 
    dependent: :destroy

end
