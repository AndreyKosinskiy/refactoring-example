RSpec.describe Manager::AccountManager do
  let(:store_path) { 'spec/fixture/account.yml' }

  let(:card_type) { 'usual' }
  let(:card_number1) { '123' }
  let(:card_number2) { '124' }
  let(:unknown_card_number) { '1111' }
  let(:unknown_login) { '1111' }
  let(:correct_login) { 'v' }
  let(:correct_password) { 'v' }
  let(:default_card1) { instance_double('Model::Card', type: card_type, balance: 50, number: card_number1) }
  let(:default_card2) { instance_double('Model::Card', type: card_type, balance: 50, number: card_number2) }
  let(:default_data1) { { name: 'A', login: 'a', password: 'a', age: 44, card: [default_card1, default_card2] } }

  let(:card_number3) { '125' }
  let(:card_number4) { '154' }
  let(:default_card3) { instance_double('Model::Card', type: card_type, balance: 50, number: card_number3) }
  let(:default_card4) { instance_double('Model::Card', type: card_type, balance: 50, number: card_number4) }
  let(:default_data2) { { name: 'V', login: 'v', password: 'v', age: 44, card: [default_card3, default_card4] } }
  let(:described_instance) { described_class.new(file_path: store_path) }
  let(:unknown_account) { instance_double('Manager::Account', login: 'unknown') }
  let(:account1) { described_instance.create(**default_data1) }
  let(:account2) { described_instance.create(**default_data2) }

  before do
    account1
    account2
  end

  after do
    File.delete(store_path) if File.exist?(store_path)
  end

  it 'create account instance' do
    expect(described_instance.create(**default_data1)).to be_a(Model::Account)
  end

  it 'return account by card number' do
    allow(described_instance).to receive(:accounts).and_return([account1, account2])
    expect(described_instance.get_by_card_number(card_number: card_number1)).to eq(account1)
  end

  it 'return false if account with input card number is not found' do
    allow(described_instance).to receive(:accounts).and_return([account1, account2])
    expect(described_instance.get_by_card_number(card_number: unknown_card_number)).to be_falsy
  end

  it 'destroy account' do
    described_instance.destroy(account: account1)
    file_accounts = YAML.load_file(store_path)
    expect(file_accounts.size).to be 1
  end

  it 'doesnt delete account' do
    described_instance.destroy(account: unknown_account)
    file_accounts = YAML.load_file(store_path)
    expect(file_accounts.size).to be 2
  end

  it 'update account when destroy action' do
    described_instance.update(account: account1, action: 'destroy')
    file_accounts = YAML.load_file(store_path)
    expect(file_accounts.size).to be 1
  end

  it 'update account when not destroy action' do
    described_instance.update(account: account1, action: '')
    file_accounts = YAML.load_file(store_path)
    expect(file_accounts.size).to be 2
  end

  it 'check account with input login in store' do
    expect(described_instance.exists?('v')).to be_truthy
  end

  it 'check store' do
    expect(described_instance.store_empty?).to eq(false)
  end

  it 'return all card from account' do
    expect(described_instance.all_cards.size).to be 4
  end

  it 'load exitst account by login and password' do
    expect(described_instance.load(login: correct_login, password: correct_password)).to be_a(Model::Account)
  end

  it 'not load account if input unknown login' do
    expect(described_instance.load(login: unknown_login, password: correct_password)).to eq(false)
  end
end
