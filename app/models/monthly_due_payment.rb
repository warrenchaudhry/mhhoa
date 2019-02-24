class MonthlyDuePayment < ApplicationRecord
  belongs_to :homeowner
  belongs_to :monthly_due_rate

  validates :amount, :billable_month, :billable_year, presence:true, allow_blank: false
  validates :amount, numericality: { greater_than: 0 }
  validate :check_amount_if_complied

  def check_amount_if_complied
    return if amount.nil?
    if amount > homeowner.monthly_rate
      self.errors.add(:amount, 'should not be greater than %d' % homeowner.monthly_rate)
    else
      true
    end
  end
end
