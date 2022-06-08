FactoryBot.define do 
  factory :user do 
    email { Faker::Internet.email }
    password_digest { "$2a$12$umz4ng5pM/rW6ebixVgVBumO30rtxsUHjSX0jeiuCiY0Pk9CsfoRm" }
    auth_token { Faker::Number.number(digits: 10) } 
  end
end
