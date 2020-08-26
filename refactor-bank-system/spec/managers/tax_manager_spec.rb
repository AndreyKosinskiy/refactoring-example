RSpec.describe Manager::TaxManager do
  it 'create tax instance' do
    expect(described_class.create(card_type: 'usual')).to be_a(Model::Tax)
  end
end
