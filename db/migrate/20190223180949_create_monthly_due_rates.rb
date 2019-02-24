class CreateMonthlyDueRates < ActiveRecord::Migration[5.2]
  def change
    create_table :monthly_due_rates do |t|
      t.decimal :amount, precision: 8, scale: 2, default: 400
      t.date :start_date, default: '2018-01-01'
      t.date :end_date
      t.boolean :recurring, default: true
      t.boolean :locked, default: true

      t.timestamps
    end
  end
end
