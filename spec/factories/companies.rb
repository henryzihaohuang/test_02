FactoryBot.define do 
  factory :company do 
    name { Faker::Company.name }
    uid { Faker::Number.number(digits: 10) }

    trait :tech_company do 
      industry { 'tech' }
    end

    trait :no_employees do 
      employees_count { 0 }
    end
  end
end
