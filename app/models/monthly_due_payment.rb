class MonthlyDuePayment < ApplicationRecord
  belongs_to :homeowner
  belongs_to :monthly_due_rate

  validates :amount, :billable_month, :billable_year, presence:true, allow_blank: false
  validates :amount, numericality: { greater_than: 0 }
  validate :check_amount_if_complied

  def homeowner_monthly_rate
    rate = monthly_due_rate&.amount || MonthlyDueRate&.first&.amount
    rate -= homeowner.monthly_dues_discount
  end

  def check_amount_if_complied
    return if amount.nil?
    if amount > homeowner_monthly_rate
      self.errors.add(:amount, 'should not be greater than %d' % homeowner_monthly_rate)
    else
      true
    end
  end
end
