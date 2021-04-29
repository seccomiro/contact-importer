FactoryBot.define do
  factory :import_contact do
    import { nil }
    error_message { "MyString" }
    name { "MyString" }
    email { "MyString" }
    birthdate { "2021-04-29" }
    phone { "MyString" }
    address { "MyString" }
    credit_card_number { "MyString" }
  end
end
