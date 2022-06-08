FactoryBot.define do 
    factory :experience do 
      candidate
      uid { Faker::Number.number(digits: 10) }
      title { "Server" } 
      employment_type { nil }
      company_name { "Oceans & Ale" } 
      company_linked_in_url { nil } 
      location { nil } 
      latitude { nil } 
      longitude { nil } 
      start_month { 8 } 
      start_year { 2011 }
      end_month { 8 }
      end_year { 2015 }
      description { nil }
      media_urls { [] }
      company_id { nil }

      trait :server do 
        title { "Server" }
      end

      trait :pilot do 
        title { "Pilot" }
      end

      trait :software_engineer do 
        title { "Software Engineer" }
      end

      trait :student_intern do 
        title { "Student Intern" }
      end

      trait :first_experience do
        title { 'Server'}
        start_year { 2011 }
        end_year { 2013 }
        company_name { 'Olive Garden' }
      end
  
      trait :second_experience do
        title { 'Pilot' }
        company_name { 'Delta' }
        start_year { 2013 }
        end_year { 2014 }
      end
  
      trait :third_experience do 
        title { nil }
        company_name { nil }
        start_year { 2014 }
        end_year { 2014 }
      end
  
      trait :current_experience do 
        title { 'Software Engineer' }
        company_name { 'Mogul' }
        description { 'Making the world a better place' }
        start_year { 2014 }
        company_linked_in_url { 'www.linkedin.com/mogul' }
        end_year { nil }
      end
    end
  end
