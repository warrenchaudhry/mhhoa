FactoryBot.define do
  factory :monthly_due_rate do
    amount { 400 }
    start_date { '2018-01-01' }
    end_date { '2022-01-31' }
    recurring { false }
  end
end
