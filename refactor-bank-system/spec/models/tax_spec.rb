RSpec.describe Model::Tax do
  let(:transaction_types) do
    {
      withdraw: [0.05, 0],
      put: [0.04, 0],
      send: [0.88, 0]
    }
  end

  let(:amount) { 20 }
  let(:described_instance) { described_class.new(transaction_types: transaction_types) }

  it 'correct calc all transaction_types' do
    transaction_types.each do |key, value|
      return_value = amount.to_i * value[0].to_f + (value[1]).to_i
      expect(described_instance.calc(amount: amount, transaction_type: key.to_s)).to eq(return_value)
    end
  end
end
