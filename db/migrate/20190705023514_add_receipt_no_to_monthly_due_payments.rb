class AddReceiptNoToMonthlyDuePayments < ActiveRecord::Migration[5.2]
  def up
    add_column :monthly_due_payments, :receipt_no, :string
  end

  def down
    remove_column :monthly_due_payments, :receipt_no
  end
end
