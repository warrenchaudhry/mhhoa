class CreateMonthlyDuePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_due_payments do |t|
      t.references :homeowner, foreign_key: true
      t.references :monthly_due_rate, foreign_key: true
      t.decimal :amount, precision: 8, scale: 2, default: 0
      t.decimal :discount, precision: 8, scale: 2, default: 0
      t.decimal :total, precision: 8, scale: 2, default: 0
      t.integer :billable_month
      t.integer :billable_year
      t.boolean :paid, default: false
      t.date :paid_at
      t.boolean :fully_paid, default: false

      t.timestamps
    end
  end
end
