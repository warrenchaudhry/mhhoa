FactoryBot.define do
  factory :homeowner do
    firstname { Faker::Name.first_name }
    mi { ('A'..'Z').to_a.sample }
    lastname { Faker::Name.first_name }
    street
    active { true }
    payment_starts_on { '2018-01-01' }
    monthly_dues_discount { 0 }
  end
end
