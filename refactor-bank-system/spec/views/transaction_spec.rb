RSpec.describe View::Transaction do
  ERROR_PHRASES = {
    choose_card_withdraw: 'Choose the card for withdrawing:',
    choose_card_put: 'Choose the card for putting:',
    choose_card_send: 'Choose the card for sending:',
    choose_card: 'Choose correct card',
    put_amount: 'Input the amount of money you want to withdraw',
    put_amount1: 'Input the amount of money you want to put on your card',
    wrong_command: 'Wrong command. Try again!',
    no_active_cards: "There is no active cards!\n",
    wrong_card_type: "Wrong card type. Try again!\n",
    wrong_number: "You entered wrong number!\n",
    correct_amount: 'You must input correct amount of money',
    tax_higher: 'Your tax is higher than input amount',
    exit: "press `exit` to exit\n",
    not_money: "You don't have enough money on card for such operation",
    recipient_enter: 'Enter the recipient card:'
  }.freeze

  WRONG_AMOUNT = '-33'.freeze
  DEFAULT_AMOUNT = '100'.freeze
  DEFAULT_CARD = '1'.freeze
  DEFAULT_CARD_SECOND = '2'.freeze

  let(:card2) { instance_double('Model::Card', type: 'usual', balance: 0, number: '123123') }
  let(:card1) { instance_double('Model::Card', type: 'usual', balance: 45, number: '456456456') }
  let(:account) { instance_double('Model::Account', card: [card1, card2]) }
  let(:described_instance) { described_class.new(current_account: account) }

  before do
    allow(card1).to receive(:balance=)
    allow(account).to receive(:save)
    allow(described_instance).to receive(:loop).and_yield
  end
  describe '#withdaraw_money' do
    it 'when not active card' do
      allow(account).to receive(:card).and_return([])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_withdraw])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:no_active_cards])
      described_instance.withdraw_money
    end

    it 'when put exit in withdraw menu' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_withdraw])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return('exit')
      expect(described_instance.withdraw_money).to be_nil
    end

    it 'when wrong amount' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_withdraw])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD, WRONG_AMOUNT)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:correct_amount])

      described_instance.withdraw_money
    end

    it 'when wrong number' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_withdraw])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return('33333')
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:wrong_number])
      described_instance.withdraw_money
    end

    it 'dont have enough money' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_withdraw])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD, '1000')
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:not_money])

      described_instance.withdraw_money
    end

    it 'correct operation' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_withdraw])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD)
      expect(described_instance).to receive(:puts).with('Money 1.0 withdrawed from 456456456. Money left: 43.95$. Tax: 0.05$')

      described_instance.withdraw_money
    end
  end

  describe '#put_money' do
    it 'when not active card' do
      allow(account).to receive(:card).and_return([])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_put])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:no_active_cards])
      described_instance.put_money
    end

    it 'when put exit in withdraw menu' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_put])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return('exit')
      expect(described_instance.put_money).to be_nil
    end

    it 'when wrong amount' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_put])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD, WRONG_AMOUNT)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount1])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:correct_amount])

      described_instance.put_money
    end

    it 'when wrong number' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_put])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return('33333')
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:wrong_number])
      described_instance.put_money
    end

    it 'when higer tax' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_put])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD, DEFAULT_AMOUNT)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount1])
      allow(described_instance.instance_variable_get(:@transaction_engine)).to receive(:put_money).and_return(false)
      expect(described_instance).to receive(:puts).with('Your tax is higher than input amount')
      described_instance.put_money
    end

    it 'result put money transaction' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_put])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD, DEFAULT_AMOUNT)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount1])
      expect(described_instance).to receive(:puts).with('Money 100.0 was put on 456456456. Balance: . Tax: 4.0')
      described_instance.put_money
    end
  end

  describe '#send_money' do
    it 'when not active card' do
      allow(account).to receive(:card).and_return([])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_send])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:no_active_cards])
      described_instance.send_money
    end
    it 'choose incorrect sender card' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_send])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return('-1')
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card])
      described_instance.send_money
    end
    it 'choose sender card correct' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_send])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return('1')
      expect(described_instance).to_not receive(:puts).with(ERROR_PHRASES[:choose_card])
      described_instance.send_money
    end
    it 'choose unknown recipient card' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_send])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD_SECOND, '1123456789101112')
      allow(Manager::CardManager).to receive(:get_by_card_number).and_return(false)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:recipient_enter])
      expect(described_instance).to receive(:puts).with("There is no card with number 1123456789101112\n")
      described_instance.send_money
    end
    it 'input wrong amount' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_send])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD_SECOND, '1123456789101112', WRONG_AMOUNT)
      allow(Manager::CardManager).to receive(:get_by_card_number).and_return(card2)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:recipient_enter])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:wrong_number])
      described_instance.send_money
    end
    it 'sender do not have money' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_send])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD, '1123456789101112', DEFAULT_AMOUNT) # 10
      allow(Manager::CardManager).to receive(:get_by_card_number).and_return(card2)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:recipient_enter])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount])
      allow_any_instance_of(Model::Transaction).to receive(:check_tax).and_return(false)
      expect(described_instance).to receive(:puts).with("You don't have enough money on card for such operation")
      described_instance.send_money
    end
    it 'correct operation send money' do
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:choose_card_send])
      expect(described_instance).to receive(:puts).with("- #{card1.number}, #{card1.type}, press 1")
      expect(described_instance).to receive(:puts).with("- #{card2.number}, #{card2.type}, press 2")
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:exit])
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(DEFAULT_CARD, '1123456789101112', DEFAULT_AMOUNT) # 10
      allow(Manager::CardManager).to receive(:get_by_card_number).and_return(card2)
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:recipient_enter])
      expect(described_instance).to receive(:puts).with(ERROR_PHRASES[:put_amount])
      expect(described_instance).to receive(:puts).with("Money 1$ was put on 456456456. Balance: 1. Tax: 1$\n")
      expect(described_instance).to receive(:puts).with("Money 1$ was put on 123123. Balance: 1. Tax: 1$\n")
      allow_any_instance_of(Model::Transaction).to receive(:check_tax).and_return(true)
      allow_any_instance_of(Model::Transaction).to receive(:send_money).and_return({ sender: { amount: 1, balance: 1, tax: 1 }, recipient: { amount: 1, balance: 1, tax: 1 } })

      described_instance.send_money
    end
  end
end
