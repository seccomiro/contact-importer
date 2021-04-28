FactoryBot.define do
  factory :user do
    email { 'user@user.com' }
    password { '321321321' }
    password_confirmation { '321321321' }
  end
end
