FactoryBot.define do
  factory :import_contact do
    import
    error_message { nil }
    name { 'Valid Contact Name' }
    email { 'contact@contact.com' }
    birthdate { '2021-04-29' }
    phone { '(+57) 320-432-05-09' }
    address { Faker::Address.full_address }
    credit_card_number { '4111111111111111' }

    trait :alternative_birthdate do
      birthdate { '20210429' }
    end

    trait :invalid_birthdate do
      birthdate { '29/04/2021' }
    end

    trait :with_error_message do
      error_message { 'Some error message' }
    end
  end
end
