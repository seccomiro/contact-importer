require 'rails_helper'

describe EmailChecker do
  let(:valid_email) { 'valid@email.com' }
  let(:another_valid_email) { 'another@email.com' }
  let!(:import) { create(:import) }
  let(:all_email_check_emails) { EmailCheck.all.pluck(:email) }
  let(:first_email_check) { EmailCheck.first }
  let(:client) { instance_double('ZeroBounceClient') }
  let(:zero_bounce_response_for_valid_emails) do
    [
      { 'address' => valid_email, 'status' => 'valid' },
      { 'address' => another_valid_email, 'status' => 'valid' }
    ]
  end
  let(:empty_zero_bounce_response) { [] }

  describe '#execute' do
    subject(:email_checker) { @email_checker }

    before do
      create(:import_contact, email: valid_email, import: import)
      create(:import_contact, email: another_valid_email, import: import)
      create(:contact, user: import.user, email: valid_email)
      create(:contact, user: import.user, email: another_valid_email)

      allow(client).to receive(:fetch)
        .with([valid_email, another_valid_email])
        .and_return(zero_bounce_response_for_valid_emails)

      @email_checker = described_class.new(import, client)
      email_checker.execute
    end

    context 'with an import with valid emails' do
      it 'returns a list of email checks for all the emails' do
        expect(all_email_check_emails).to contain_exactly(valid_email, another_valid_email)
      end

      # FIX: We cannot test intermediate states right now because we are running synchronously
      # it 'creates email checks with checking status' do
      #   expect(first_email_check).to be_checking
      # end
    end

    context 'when executing a second time with the same emails' do
      before do
        allow(client).to receive(:fetch)
          .with([])
          .and_return(empty_zero_bounce_response)
      end

      it 'does not raise an error' do
        expect { email_checker.execute }.not_to raise_error
      end

      it 'returns a list of email checks for all the emails' do
        email_checker.execute

        expect(all_email_check_emails).to contain_exactly(valid_email, another_valid_email)
      end
    end

    context 'when another user tries to execute with the same emails' do
      subject(:another_user_email_checker) { @another_user_email_checker }

      let(:another_user) { create(:user) }
      let(:another_user_import) { create(:import, user: another_user) }

      before do
        create(:import_contact, email: valid_email, import: another_user_import)
        create(:import_contact, email: another_valid_email, import: another_user_import)
        create(:contact, email: valid_email, user: another_user)
        create(:contact, email: another_valid_email, user: another_user)

        allow(client).to receive(:fetch)
          .with([])
          .and_return(empty_zero_bounce_response)

        @another_user_email_checker = described_class.new(another_user_import, client)
        another_user_email_checker.execute
      end

      it 'does not raise an error' do
        expect { another_user_email_checker.execute }.not_to raise_error
      end

      it 'returns a list of email checks for all the emails' do
        expect(all_email_check_emails).to contain_exactly(valid_email, another_valid_email)
      end
    end

    context 'when executing with one new email and one existing email' do
      let(:another_user) { create(:user) }
      let(:another_user_import) { create(:import, user: another_user) }
      let(:another_user_email_checker) { described_class.new(another_user_import, client) }
      let(:one_more_valid_email) { 'one_more@email.com' }
      let(:zero_bounce_response_for_one_more_valid_email) do
        [
          { 'address' => one_more_valid_email, 'status' => 'valid' }
        ]
      end
      let(:current_email_checks) { EmailCheck.where(email: [valid_email, one_more_valid_email]).pluck(:email) }

      before do
        create(:import_contact, email: valid_email, import: another_user_import)
        create(:import_contact, email: one_more_valid_email, import: another_user_import)
        create(:contact, email: valid_email, user: another_user)
        create(:contact, email: one_more_valid_email, user: another_user)

        allow(client).to receive(:fetch)
          .with([one_more_valid_email])
          .and_return(zero_bounce_response_for_one_more_valid_email)
      end

      it 'does not raise an error' do
        expect { another_user_email_checker.execute }.not_to raise_error
      end

      it 'returns a list of email checks that contains both emails' do
        another_user_email_checker.execute

        expect(current_email_checks).to contain_exactly(valid_email, one_more_valid_email)
      end
    end

    context 'with an inline sychronous execution' do
      it 'sets a good status after it ends' do
        expect(first_email_check).to be_good
      end
    end
  end
end
