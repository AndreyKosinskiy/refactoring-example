RSpec.describe Controller::Console do
  let(:described_instance) { described_class.new }

  CMD_COMMAND = {
    load: 'load',
    create: 'create',
    exit: 'exit'
  }.freeze

  it 'create account menu' do
    allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(CMD_COMMAND[:create])
    allow(described_instance.instance_variable_get(:@view_account)).to receive(:create).and_return(true)
    allow_any_instance_of(Controller::MainMenu).to receive(:main_menu).and_return(true)

    expect(described_instance.instance_variable_get(:@view_account)).to receive(:create)
    described_instance.console
  end
  it 'load account menu' do
    allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(CMD_COMMAND[:load])
    allow(described_instance.instance_variable_get(:@view_account)).to receive(:load).and_return(true)
    allow_any_instance_of(Controller::MainMenu).to receive(:main_menu).and_return(true)

    expect(described_instance.instance_variable_get(:@view_account)).to receive(:load)
    described_instance.console
  end

  it 'exit from  controller' do
    allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(CMD_COMMAND[:exit])
    allow_any_instance_of(Controller::MainMenu).to receive(:main_menu).and_return(true)
    expect(described_instance).to receive(:exit)
    described_instance.console
  end
end

RSpec.describe Controller::MainMenu do
  let(:account) { instance_double('Model::Account', name: 'andre') }
  let(:view_account) { instance_double('View::Account') }
  let(:described_instance) { described_class.new(current_account: account, view_account: view_account) }
  TRY_AGAIN = "Wrong command. Try again!\n".freeze
  MAIN_MENU_COMMAND = %w[SC CC DC PM WM SM DA exit else].freeze

  before do
    allow(described_instance).to receive(:loop).and_yield
  end
  describe 'card' do
    it 'show card' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(MAIN_MENU_COMMAND[0])
      expect(described_instance.instance_variable_get(:@view_card)).to receive(:show_cards)
      described_instance.main_menu
    end
    it 'create_card' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(MAIN_MENU_COMMAND[1])
      expect(described_instance.instance_variable_get(:@view_card)).to receive(:create_card)
      described_instance.main_menu
    end
    it 'destroy card' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(MAIN_MENU_COMMAND[2])
      expect(described_instance.instance_variable_get(:@view_card)).to receive(:destroy_card)
      described_instance.main_menu
    end
  end
  describe 'transaction' do
    it 'put money' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(MAIN_MENU_COMMAND[3])
      expect(described_instance.instance_variable_get(:@view_transaction)).to receive(:put_money)
      described_instance.main_menu
    end
    it 'withdraw money' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(MAIN_MENU_COMMAND[4])
      expect(described_instance.instance_variable_get(:@view_transaction)).to receive(:withdraw_money)
      described_instance.main_menu
    end
    it 'send money' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(MAIN_MENU_COMMAND[5])
      expect(described_instance.instance_variable_get(:@view_transaction)).to receive(:send_money)
      described_instance.main_menu
    end
  end
  it 'destroy account' do
    allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(MAIN_MENU_COMMAND[6])
    allow(described_instance.instance_variable_get(:@view_account)).to receive(:destroy_account).and_return(true)
    expect(described_instance).to receive(:exit)
    expect(described_instance.instance_variable_get(:@view_account)).to receive(:destroy_account)
    described_instance.main_menu
  end

  it 'exit' do
    allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(MAIN_MENU_COMMAND[7])
    expect(described_instance).to receive(:exit)
    described_instance.main_menu
  end
end
