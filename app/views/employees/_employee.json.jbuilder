json.extract! employee, :id, :firstname, :lastname, :start_date, :end_date, :employee_type, :rate, :payment_mode, :active, :created_at, :updated_at
json.url employee_url(employee, format: :json)
