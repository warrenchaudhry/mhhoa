FactoryBot.define do
  factory :monthly_due_payment do
    homeowner
    monthly_due_rate
    amount { 400 }
    discount { 0 }
    total { 400 }
    billable_month { 1 }
    billable_year { Date.today.year }
    paid { true }
    paid_at { Date.today }
    fully_paid { true }
  end
end
