FactoryBot.define do 
  factory :app_session do 
    user
    start_time { Date.today.beginning_of_day }
    duration { 293 }
  end
end
