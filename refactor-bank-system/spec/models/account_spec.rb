RSpec.describe Model::Account do
  let(:init_value) { { name: 'Andrey', login: 'Andrey', password: 'Andrey', age: 50 } }
  let(:card_type) { 'usual' }
  let(:described_instance) { described_class.new(**init_value) }

  before do
    described_instance.add_card(type: card_type)
  end

  it 'decrease number of card in account' do
    current_number_card = described_instance.card.length
    will_expect_number = current_number_card - 1
    expect { described_instance.destroy_card(position: 0) }.to change { described_instance.card.length }.from(current_number_card).to(will_expect_number)
  end

  it 'increace number of card in account' do
    expect { described_instance.add_card(type: card_type) }.to change { described_instance.card.length }.by(1)
  end

  it 'show not empty cards list in account' do
    described_instance.add_card(type: card_type)
    expect(described_instance.show_cards).to_not eq([])
  end
end
