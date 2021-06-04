FactoryBot.define do
  factory :import do
    user
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/fixtures/files/3correct.csv'), 'text/plain') }

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

    trait :all_header_values_invalid do
      headers do
        {
          'name' => 'xxx',
          'email' => 'xxx',
          'birthdate' => 'xxx',
          'phone' => 'xxx',
          'address' => 'xxx',
          'credit_card' => 'xxx'
        }
      end
    end
  end
end
