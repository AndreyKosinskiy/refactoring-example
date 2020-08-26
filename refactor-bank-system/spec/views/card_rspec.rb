RSpec.describe View::Card do
  ERROR_PHRASES = {
    user_not_exists: 'There is no account with given credentials',
    wrong_command: 'Wrong command. Try again!',
    no_active_cards: "There is no active cards!\n",
    wrong_card_type: "Wrong card type. Try again!\n",
    wrong_number: "You entered wrong number!\n",
    correct_amount: 'You must input correct amount of money',
    tax_higher: 'Your tax is higher than input amount'
  }.freeze

  let(:unknown_type) { 'unknown' }
  let(:avalible_type) { 'usual' }
  let(:account) { double_instance('Model::Account') }
  let(:described_instance) { described_class.new }

  describe '#create_card' do
    it 'create card if input avalible card type' do
      allow(described_instance).to receive_messave_chain(:gets, :chomp).and_return(avalible_type)
      expect(account).to receive(:save)
    end

    it 'not create card if input unknown card type' do
      error = ERROR_PHRASES[:wrong_card_type]
      allow(described_instance).to receive_messave_chain(:gets, :chomp).and_return(unknown_type)
      expect(described_instance).to output(/#{error}/).to_stdout
      described_instance.create_card
    end
  end

  describe '#destroy_card' do
  end

  describe '#show_cards' do
    it 'show avalible card' do
      skip
    end

    it 'not show card if cards not found' do
      skip
    end
  end
end
