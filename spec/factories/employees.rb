FactoryBot.define do
  factory :employee do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    start_date { Date.today.beginning_of_month }
    end_date { nil }
    employee_type { 0 }
    rate { 300 }
    payment_mode { 0 }
    active { true }
  end
end
