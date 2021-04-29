FactoryBot.define do
  factory :contact do
    name { 'MyString' }
    email { 'MyString' }
    birthdate { DateTime.now }
    phone { 'MyString' }
    address { 'MyString' }
    user
  end
end
