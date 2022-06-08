FactoryBot.define do 
  factory :search_performed do 
    user
    query { 'manager' }
    filters {{ gender_diverse: 'true', keywords: 'peruvian' }}
    page { 1 }
    per_page { 10 }
  end
end
