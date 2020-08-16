RSpec.describe View::Card do
  COMMON_PHRASES = {
    create_first_account: "There is no active accounts, do you want to be the first?[y/n]\n",
    destroy_account: "Are you sure you want to destroy account?[y/n]\n",
    if_you_want_to_delete: 'If you want to delete:',
    choose_card: 'Choose the card for putting:',
    choose_card_withdrawing: 'Choose the card for withdrawing:',
    input_amount: 'Input the amount of money you want to put on your card',
    withdraw_amount: 'Input the amount of money you want to withdraw',
    exit: "press `exit` to exit\n"
  }.freeze

  ERROR_PHRASES = {
    user_not_exists: 'There is no account with given credentials',
    wrong_command: 'Wrong command. Try again!',
    no_active_cards: "There is no active cards!\n",
    wrong_card_type: "Wrong card type. Try again!\n",
    wrong_number: "You entered wrong number!\n",
    correct_amount: 'You must input correct amount of money',
    tax_higher: 'Your tax is higher than input amount'
  }.freeze

  let(:exit_command) { 'exit' }
  let(:yes) { 'y' }
  let(:order) { '1' }
  let(:unknown_order) { '12' }
  let(:unknown_type) { 'unknown' }
  let(:avalible_type) { 'usual' }
  let(:card1) { instance_double('Model::Card', type: avalible_type, balance: 50, number: '123123123') }
  let(:account) { instance_double('Model::Account', save: '', card: []) }

  let(:described_instance) { described_class.new(current_account: account) }

  before do
    allow(described_instance).to receive(:loop).and_yield
  end
  describe '#create_card' do
    it 'create card if input avalible card type' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(avalible_type)
      expect(described_instance.instance_variable_get(:@current_account)).to receive(:save)
      described_instance.create_card
    end

    it 'not create card if input unknown card type' do
      error = ERROR_PHRASES[:wrong_card_type]
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(unknown_type)
      expect { described_instance.create_card }.to output(/#{error}/).to_stdout
    end
  end

  describe '#destroy_card' do
    it 'account has not card' do
      error = ERROR_PHRASES[:no_active_cards]
      expect { described_instance.destroy_card }.to output(/#{error}/).to_stdout
    end

    describe 'account with card' do
      before do
        allow(account).to receive(:card).and_return([card1])
      end
      it 'exit from menu destroy card' do
        allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(exit_command)
        allow(account).to receive(:card).and_return([card1])
        expect(described_instance.destroy_card).to be_nil
      end

      it 'account has 1 card and choose unknow order' do
        error = ERROR_PHRASES[:wrong_number]
        card_raw = "\n- #{card1.number}, #{card1.type}, press 1\n"
        message = COMMON_PHRASES[:if_you_want_to_delete] + card_raw + COMMON_PHRASES[:exit] + error.to_s
        allow(account).to receive(:card).and_return([card1])
        allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(unknown_order, '')
        expect { described_instance.destroy_card }.to output(message).to_stdout

        described_instance.destroy_card
      end

      it 'account has 1 card and choose destroy this card, and do not agree' do
        allow(account).to receive(:card).and_return([card1])
        allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(order, '')
        expect(described_instance.destroy_card).to be_nil
      end

      it 'account has 1 card and choose destroy this card' do
        allow(account).to receive(:card).and_return([card1])
        allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(order, yes)
        expect(Manager::CardManager).to receive(:destroy)
        described_instance.destroy_card
      end
      describe '#show_cards' do
        it 'show avalible card' do
          message = "- #{card1.number}, #{card1.type}\n"
          expect { described_instance.show_cards }.to output(message).to_stdout
        end

        it 'not show card if cards not found' do
          allow(account).to receive(:card).and_return([])
          expect { described_instance.show_cards }.to output(ERROR_PHRASES[:no_active_cards]).to_stdout
          described_instance.show_cards
        end
      end
    end
  end
end
