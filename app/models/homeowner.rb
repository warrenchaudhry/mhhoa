class Homeowner < ApplicationRecord
  belongs_to :street
  has_many :monthly_due_payments, dependent: :destroy
  validates :firstname, :lastname, :street, presence: true

  scope :active, -> { where(active: true) }

  def full_name
    [lastname, firstname].join(', ')
  end

  def monthly_rate
    @monthly_rate ||= monthly_due_rate
  end

  def monthly_due_rate
    rate = MonthlyDueRate&.first&.amount || 0
    rate -= monthly_dues_discount

    return 0 if rate.negative?

    rate
  end

  def self.payments_data(year: Date.today.year)
    data = {}
    group = Homeowner.active.joins(:street).includes(:street, :monthly_due_payments).order('streets.position ASC').to_a.group_by { |h| h.street.name }
    group.each do |street, homeowners|
      items = homeowners.sort_by(&:created_at).map { |h| h.build_payment_data(year: year) }
      data[street] = items
    end
    data
  end

  def build_payment_data(year: Date.today.year)
    data = []
    current_payments = monthly_due_payments.where(billable_year: year, paid: true).order(billable_month: :asc)
    1.upto(12).each do |idx|
      chk_date = Date.new(year.to_i, idx, 1)
      if payment_starts_on && payment_starts_on.beginning_of_month > chk_date && current_payments.empty?
        data << { inactive: true, status: 'inactive' }
        next
      end
      payments = current_payments.select { |p| p.billable_month == idx }
      # byebug if payments.pluck(:id).include?(9)
      disabled = if payments.select { |p| p.paid_at == Date.current }.any?
                   false
                 elsif year.to_s != Date.current.year.to_s && payments.empty?
                   false
                 elsif payments.any? || (idx != 1 && !data[idx - 2][:paid])
                   true
                 else
                   false
                 end
      hsh = if payments.any?
              {
                id: payments.last.id,
                receipt_no: payments.map(&:receipt_no).compact.uniq.join(', '),
                paid_at: payments.last.paid_at.strftime('%b %d, %Y'),
                total: payments.sum(&:total),
                paid: true,
                discount: monthly_dues_discount,
                amount_required: monthly_rate,
                disabled: disabled,
                status: payments.sum(&:total) < monthly_rate ? 'partial' : 'paid'
              }
            elsif payment_starts_on && chk_date < payment_starts_on.beginning_of_month
              {
                inactive: true,
                status: 'inactive'
              }
            else
              {
                paid: false,
                discount: monthly_dues_discount,
                amount_required: monthly_rate,
                disabled: disabled,
                status: 'pending'
              }
            end
      data << hsh.merge!(month: idx, year: year)
    end
    { id: id, name: full_name, payments: data }
  end
end
