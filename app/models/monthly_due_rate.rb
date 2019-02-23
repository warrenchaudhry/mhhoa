class MonthlyDueRate < ApplicationRecord
  validates :amount, :start_date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :end_date, presence: true, unless: -> { recurring? }
end
