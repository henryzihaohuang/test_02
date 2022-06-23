FactoryBot.define do 
  factory :education do 
    association :candidate
    uid

    school_name { Faker::University.name }
    degree { "Bachelors" }
    description { Faker::Hipster.sentences }
    activities_and_societies { Faker::Lorem.sentences }
    school_url { 'www.mogulschool.com' }
    start_month { '04' }
    start_year { '1991' }
    end_month { '06' }
    end_year { '1995' }

    trait :has_graduated do 
      start_year { Date.current.year - 8 }
      start_month { Date.current.month }
      end_year { Date.current.year - 4 }
      end_month { Date.current.month + 1 }
    end

    trait :current_student do 
      start_year { Date.current.year - 1 }
      start_month { Date.current.month }
      end_year { Date.current.year + 3 }
      end_month { Date.current.month + 1 }
    end

    trait :without_dates do 
      start_year { nil }
      start_month { nil }
      end_year { nil }
      end_month { nil }
    end

    trait :first_education do
      start_year { 2011 }
      end_year { 2013 }
    end

    trait :second_education do
      start_year { 2013 }
      end_year { 2014 }
    end

    trait :third_education do 
      start_year { 2014 }
      end_year { 2014 }
    end

    trait :current_education do 
      start_year { 2014 }
      end_year { nil }
    end
  end
end
