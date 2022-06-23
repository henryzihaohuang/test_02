FactoryBot.define do 
  factory :candidate do 
    full_name { Faker::Name.name }
    uid
  end
end
