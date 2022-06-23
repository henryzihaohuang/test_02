FactoryBot.define do 
  factory :candidate do 
    full_name { Faker::Name.name }
    uid { Faker::Number.number(50..100) }
  end
end
