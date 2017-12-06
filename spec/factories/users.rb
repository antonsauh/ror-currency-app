FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    username { Faker::Internet.user_name }
    password 'PASSWORD'
    password_confirmation 'PASSWORD'
  end
end
