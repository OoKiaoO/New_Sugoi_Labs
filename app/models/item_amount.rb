class ItemAmount < ApplicationRecord
  belongs_to :item

  validates :amount,
            presence: true,
            numericality: { greater_than_or_equal_to: 1 }
  validates :exp_date,
            presence: true
  validates :exp_amount,
            presence: true, if: :checked,
            numericality: { less_than_or_equal_to: :amount, greater_than_or_equal_to: 0 }
end
