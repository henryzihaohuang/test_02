FactoryBot.define do 
  factory :pipeline do 
    user
    name { Faker::Coffee.blend_name }
  end
end
