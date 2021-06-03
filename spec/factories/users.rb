FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@user.com" }
    password { '321321321' }
    password_confirmation { password }
  end
end
