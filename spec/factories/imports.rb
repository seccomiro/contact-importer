FactoryBot.define do
  factory :import do
    user
    file { File.open(Rails.root.join('spec/fixtures/files/3correct.csv')) }
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

    trait :empty_headers do
      headers do
        {
          'name' => '',
          'email' => '',
          'birthdate' => '',
          'phone' => '',
          'address' => '',
          'credit_card' => ''
        }
      end
    end
  end
end
