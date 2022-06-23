FactoryBot.define do 
  factory :candidate do 
    full_name { Faker::Name.name }
  end
end
