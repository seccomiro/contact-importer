FactoryBot.define do
  factory :credit_card_data, class: OpenStruct do
    trait :valid do
      credit_cards do
        [
          { issuer: 'American Express', number: '341111111111111' },
          { issuer: 'Bankcard', number: '5602221111111111' },
          { issuer: 'UkrCard', number: '6042009911111111' },
          { issuer: 'UkrCard', number: '6042009911111111222' },
          { issuer: 'MIR', number: '2200111111111111' },
          { issuer: 'Switch', number: '5641821111111111' },
          { issuer: 'Switch', number: '564182111111111122' },
          { issuer: 'Switch', number: '5641821111111111223' }
        ]
      end
    end
    trait :formatted do
      credit_cards do
        [
          { issuer: 'Bankcard', number: '5602 2211 1111 1111' },
          { issuer: 'Bankcard', number: '5602-2211-1111-1111' },
          { issuer: 'Bankcard', number: '5602.2211.1111.1111' }
        ]
      end
    end
    trait :nonexisting_issuer do
      credit_cards { '0000000000000000' }
    end
    trait :invalid_length_cards do
      credit_cards do
        [
          { issuer: 'Switch', number: '564182111111111' },
          { issuer: 'Discover Card', number: '644111111111111' }
        ]
      end
    end
    trait :invalid_min_max_length_cards do
      credit_cards do
        [
          { issuer: 'UkrCard', number: '60400100' },
          { issuer: 'UkrCard', number: '4' },
          { issuer: 'UkrCard', number: '' },
          { issuer: 'Discover Card', number: '64411111111111111111' },
          { issuer: 'Diners Club United States & Canada', number: '54111111111111111111' }
        ]
      end
    end
  end
end
