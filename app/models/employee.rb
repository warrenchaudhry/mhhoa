class Employee < ApplicationRecord
  validates :firstname, :lastname, :rate, presence: true
  validates :rate, numericality: { greater_than: 0 }
  enum employee_type: [:guard, :maintenance, :utility]
  enum payment_mode: [:daily, :month, :fixed_rate]

  def full_name
    [firstname, lastname].select(&:present?).map(&:titleize).join(' ')
  end
end
