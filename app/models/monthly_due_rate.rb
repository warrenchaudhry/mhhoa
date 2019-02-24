class MonthlyDueRate < ApplicationRecord
  has_many :monthly_due_payments, dependent: :nullify
  validates :amount, :start_date, presence: true
  validates :amount, numericality: { greater_than: 0 }
  # validates :end_date, presence: true, unless: -> { recurring? }
end
