FactoryBot.define do
  factory :import do
    user { nil }
    file { 'MyString' }
    status { 1 }
  end
end
