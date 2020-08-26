RSpec.describe Model::Transaction do
  let(:tax_manager) { class_double('Manager::TaxManager') }
  let(:tax_instance) { instance_double('Model::Tax') }
  let(:account_instance) { instance_double('Model::Account', card: [card1, card2]) }
  let(:described_instance) { described_class.new(account: account_instance, tax_manager: tax_manager) }

  let(:amount) { 20.0 }
  let(:card1) { instance_double('Model::Card', balance: 50, type: 'usual', number: '12345') }
  let(:card2) { instance_double('Model::Card', balance: 100, type: 'capitalist', number: '12345') }
  let(:tax1) { 1 }
  let(:incorrect_amount) { 200 }

  before do
    allow_any_instance_of(Manager::AccountManager).to receive(:get_by_card_number).with(card_number: card2.number).and_return(account_instance)
    allow_any_instance_of(Model::Card).to receive(:number)
    allow(tax_manager).to receive(:create).and_return(tax_instance)
    allow(tax_instance).to receive(:calc).and_return(tax1)
    allow(card1).to receive(:balance=)
    allow(account_instance).to receive(:save)
  end

  it 'it withdraw money from card1' do
    money_left = card1.balance - amount - tax1
    expect_return = { money_left: money_left, amount: amount, tax_value: tax1 }
    expect(described_instance.withdraw_money(amount: amount, card: card1)).to eq(expect_return)
  end

  it 'return false if withdraw money imposible from card' do
    expect_return = false
    expect(described_instance.withdraw_money(amount: incorrect_amount, card: card1)).to eq(expect_return)
  end

  it 'it put money from card1' do
    money_left = card1.balance + amount - tax1
    expect_return = { money_left: money_left, amount: amount, tax_value: tax1 }
    expect(described_instance.put_money(amount: amount, card: card1)).to eq(expect_return)
  end

  it 'return false if tax is bigger then amount, when put money' do
    allow(tax_instance).to receive(:calc).and_return(incorrect_amount * 2)
    expect_return = false
    expect(described_instance.put_money(amount: incorrect_amount, card: card1)).to eq(expect_return)
  end

  it 'it send money from card1' do
    sender_balance = card1.balance - amount - tax1
    recepient_balance = card2.balance + amount - tax1

    expect_return = {
      sender: { amount: amount, balance: sender_balance, tax: tax1 },
      recipient: { amount: amount, balance: recepient_balance, tax: tax1 }
    }
    expect(described_instance.send_money(amount: amount, sender_card: card1, recipient_card: card2)).to eq(expect_return)
  end

  describe 'check_tax' do
    it ' check put money transaction' do
      allow(tax_instance).to receive(:calc).and_return(incorrect_amount * 2)
      expect_return = false
      expect(described_instance.check_tax(amount: incorrect_amount, card: card1, type: :put)).to eq(expect_return)
    end

    it 'check send and withdraw transaction ' do
      expect_return = false
      expect(described_instance.check_tax(amount: incorrect_amount, card: card1, type: :send)).to eq(expect_return)
    end
  end
end
