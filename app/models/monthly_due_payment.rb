class MonthlyDuePayment < ApplicationRecord
  belongs_to :homeowner
  belongs_to :monthly_due_rate

  validates :amount, :billable_month, :billable_year, :paid_at, presence: true, allow_blank: false
  validates :amount, numericality: { greater_than: 0 }
  validates_uniqueness_of :receipt_no, scope: [:billable_month, :billable_year], allow_blank: true
  validate :check_paid_at
  validate :check_amount_if_complied

  def self.process_batch_payments(payment_params, paid_at)
    monthly_due_rate = MonthlyDueRate.first
    unprocessed = []
    processed = []
    payment_params.each do |homeowner_id, items|
      homeowner = Homeowner.find_by(id: homeowner_id)
      if homeowner
        items.each do |date, val|
          new_record = false
          updated = false
          year, month = date.split('-')
          mp = homeowner.monthly_due_payments.find_or_initialize_by(billable_month: month, billable_year: year)
          attr = { amount: homeowner.monthly_rate, total: homeowner.monthly_rate, monthly_due_rate_id: monthly_due_rate.id, paid_at: paid_at }
          paid = val.to_bool
          if mp.new_record?
            next unless paid
            attr.merge!(paid: true, fully_paid: true)
            new_record = true
          else
            attr.merge!(paid: val, fully_paid: val)
            updated = mp.paid? != paid
          end

          if mp.update(attr)
            processed << { payment_id: mp.id, amount: mp.amount } if new_record || updated
          else
            unprocessed << { id: homeowner_id, error: 'payment_not_saved', date: date, reason: mp.errors.full_messages }
          end
        end
      else
        unprocessed << { id: homeowner_id, error: 'homeowner_not_found' }
      end
    end
    [processed, unprocessed]
  end

  def note
    return nil if fully_paid
    '(partial - %s)' % amount
  end

  def check_amount_if_complied
    return if amount.nil?
    self.errors.add(:amount, 'should not be greater than %d' % homeowner.monthly_rate) if amount > homeowner.monthly_rate
  end

  def check_paid_at
    return if paid_at.nil?
    self.errors.add(:paid_at, 'should not be in future') if paid_at > Date.current
  end
end
