FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Contact #{n}" }
    sequence(:email) { |n| "contact#{n}@contact.com" }
    birthdate { DateTime.now }
    phone { '(+57) 320-432-05-09' }
    address { Faker::Address.full_address }
    user
  end
end
