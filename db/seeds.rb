user = User.create(email: 'user@user.com', password: '321321321', password_confirmation: '321321321')
10.times do
  contact = user.contacts.create(
    name: Faker::FunnyName.unique.two_word_name,
    email: Faker::Internet.unique.email,
    birthdate: Faker::Date.between(from: 100.years.ago, to: Date.today),
    phone: '(+57) 320-432-05-09',
    address: Faker::Address.full_address
  )
  contact.create_credit_card(
    number: Faker::Finance.credit_card(:visa)
  )
end
