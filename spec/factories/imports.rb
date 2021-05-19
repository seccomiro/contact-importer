FactoryBot.define do
  factory :import do
    user
    headers do
      {
        'name' => 'name',
        'email' => 'email',
        'birthdate' => 'birthdate',
        'phone' => 'phone',
        'address' => 'address',
        'credit_card' => 'credit_card_number'
      }
    end
  end
end
