FactoryBot.define do 
  factory :candidate do 
    full_name { Faker::Name.name }
    uid { Faker::Number.number(digits: 10) }
  end
end
