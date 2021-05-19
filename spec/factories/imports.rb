FactoryBot.define do
  factory :import do
    user
    file { 'contacts.csv' }
  end
end
