FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Contact Name #{(65 + n % 26).chr}" }
    sequence(:email) { |n| "contact#{n}@contact.com" }
    birthdate { DateTime.now }
    phone { '(+57) 320-432-05-09' }
    address { Faker::Address.full_address }
    user

    trait :alternative_valid_name do
      name { 'Valid-contact-name' }
    end

    trait :invalid_name do
      name { 'Inv4lid contact name' }
    end

    trait :alternative_valid_phone do
      phone { '(+57) 320 432 05 09' }
    end

    trait :invalid_phone do
      phone { '(45) 99999-9999' }
    end
  end
end
