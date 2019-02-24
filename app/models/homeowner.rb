class Homeowner < ApplicationRecord
  belongs_to :street
  has_many :monthly_due_payments, dependent: :destroy
  validates :firstname, :lastname, :street, presence: true

  scope :active, -> { where(active: true) }

  def full_name
    [lastname, firstname].join(', ')
  end

  def monthly_rate
    rate = MonthlyDueRate&.first&.amount || 0
    rate -= monthly_dues_discount
    return 0 if rate < 0
    rate
  end

  def self.payments_data(year: Date.today.year)
    data = {}
    group = Homeowner.active.joins(:street).includes(:street).order(lastname: :asc).group_by { |h| h.street.name }
    group.each do |street, homeowners|
      items = homeowners.collect { |h| h.build_payment_data(year: year) }
      data[street] = items
    end
    data
  end

  def build_payment_data(year: Date.today.year)
    data = []
    1.upto(12).each do |i|
      payments = MonthlyDuePayment.includes(:monthly_due_payments, :street).where(billable_year: year, billable_month: i, paid: true)
      hsh = if payments.any?
              { id: payments.last.id, paid_at: payments.last.paid_at, total: payments.sum(&:total), paid: true, discount: monthly_dues_discount, amount_required: monthly_rate }
            else
              { paid: false, discount: monthly_dues_discount, amount_required: monthly_rate }
            end
      data << hsh.merge!(month: i, year: year)
    end
    { id: id, name: full_name, payments: data }
  end
end
