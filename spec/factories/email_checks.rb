FactoryBot.define do
  factory :email_check do
    sequence(:email) { |n| "contact#{n}@contact.com" }
    status { :on_hold }
  end
end
