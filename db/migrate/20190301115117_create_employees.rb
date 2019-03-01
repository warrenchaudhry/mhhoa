class CreateEmployees < ActiveRecord::Migration[5.2]
  def up
    create_table :employees do |t|
      t.string :firstname
      t.string :lastname
      t.date :start_date
      t.date :end_date
      t.integer :employee_type, default: 0
      t.decimal :rate, default: 0
      t.integer :payment_mode, default: 0
      t.boolean :active, default: true

      t.timestamps
    end
  end

  def down
    drop_table :employees
  end
end
