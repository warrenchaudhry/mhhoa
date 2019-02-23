class AddPaymentStartsOnToHomeowners < ActiveRecord::Migration[5.2]
  def change
    add_column :homeowners, :payment_starts_on, :date, default: '2012-01-01'
    add_column :homeowners, :monthly_dues_discount, :decimal, precision: 8, scale: 2, default: 0
  end
end
