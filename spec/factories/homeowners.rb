FactoryBot.define do
  factory :homeowner do
    firstname { Faker::Name.first_name }
    mi { ('A'..'Z').to_a.sample }
    lastname { Faker::Name.first_name }
    street
    active { true }
  end
end
