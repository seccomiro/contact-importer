FactoryBot.define do
  factory :email_check do
    sequence(:email) { |n| "contact#{n}@contact.com" }
    status { :checking }
  end
end
