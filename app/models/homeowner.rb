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
    group = Homeowner.active.joins(:street).includes(:street).order('streets.position ASC').group_by { |h| h.street.name }
    group.each do |street, homeowners|
      items = homeowners.collect { |h| h.build_payment_data(year: year) }
      data[street] = items
    end
    data
  end

  def build_payment_data(year: Date.today.year)
    data = []
    1.upto(12).each do |idx|
      chk_date = Date.new(year.to_i, idx, 1)
      if payment_starts_on && payment_starts_on.beginning_of_month > chk_date
        data << { inactive: true, status: 'inactive'  }
        next
      end
      payments = monthly_due_payments.where(billable_year: year, billable_month: idx, paid: true)
      # byebug if payments.pluck(:id).include?(9)
      disabled = if payments.where(paid_at: Date.current).any?
                   false
                 elsif year.to_s != Date.current.year.to_s && payments.empty?
                   false
                 elsif payments.any? || (idx != 1 && !data[idx - 2][:paid])
                   true
                 else
                   false
                 end
      hsh = if payments.any?
              { id: payments.last.id, paid_at: payments.last.paid_at, total: payments.sum(&:total), paid: true, discount: monthly_dues_discount, amount_required: monthly_rate, disabled: disabled, status: ((payments.sum(&:total) < monthly_rate) ? 'partial' : 'paid') }
            else
              { paid: false, discount: monthly_dues_discount, amount_required: monthly_rate, disabled: disabled, status: 'pending' }
            end
      data << hsh.merge!(month: idx, year: year)
    end
    { id: id, name: full_name, payments: data }
  end
end
