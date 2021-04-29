FactoryBot.define do
  factory :contact do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    birthdate { DateTime.now }
    phone { '(+57) 320-432-05-09' }
    address { Faker::Address.full_address }
    user
  end
end
