FactoryBot.define do
  factory :credit_card do
    number { Faker::Finance.credit_card(:visa) }
    contact
  end
end
