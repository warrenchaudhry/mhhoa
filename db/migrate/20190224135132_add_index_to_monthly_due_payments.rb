class AddIndexToMonthlyDuePayments < ActiveRecord::Migration[5.2]
  def change
    add_index :monthly_due_payments, :billable_month
    add_index :monthly_due_payments, :billable_year
    add_index :monthly_due_payments, [:billable_month, :billable_year]
  end
end
