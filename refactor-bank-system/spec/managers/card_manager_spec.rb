RSpec.describe Manager::CardManager do
  let(:card_type) { 'usual' }
  let(:card_number) { '123' }
  let(:not_found_number_card) { '124' }
  let(:default_card) { instance_double('Model::Card', type: card_type, balance: 50, number: card_number) }
  let(:account) { instance_double('Model::Account', card: [default_card]) }

  before do
    allow_any_instance_of(Manager::AccountManager).to receive(:all_cards).and_return([default_card])
  end

  it 'create card instance' do
    expect(described_class.create(type: card_type)).to be_a(Model::Card)
  end

  it 'destroy card from account' do
    expect(account).to receive(:card).and_return([])
    described_class.destroy(account: account, card_number: card_number)
  end

  it 'not destroy card from account if card not in account' do
    expect(described_class.destroy(account: account, card_number: not_found_number_card)).to eq(account.card)
  end

  it 'show all card in account' do
    expect(described_class.show_cards(account: account)).to eq(account.card)
  end

  it 'get card by has number' do
    expect(described_class.get_by_card_number(card_number: card_number)).to eq(default_card)
  end

  it 'return false if card is not found' do
    expect(described_class.get_by_card_number(card_number: not_found_number_card)).to be_falsy
  end
end
