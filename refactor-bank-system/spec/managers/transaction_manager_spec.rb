RSpec.describe Manager::TransactionManager do
  let(:account) { instance_double('Model::Account') }
  it 'return transaction instance' do
    expect(described_class.create(account: account)).to be_a(Model::Transaction)
  end
end
