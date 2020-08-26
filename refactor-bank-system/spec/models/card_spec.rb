RSpec.describe Model::Card do
  let(:init_value) { { type: 'usual', balance: 50 } }
  let(:described_instance) { described_class.new(**init_value) }
  let(:described_instance2) { described_class.new(**init_value) }

  it 'create card with generated card number' do
    length_card_number = described_instance.number.length
    expect(length_card_number).to eq(16)
  end

  it 'create uniq card number' do
    expect(described_instance.number).to_not eq(described_instance2.number)
  end
end
