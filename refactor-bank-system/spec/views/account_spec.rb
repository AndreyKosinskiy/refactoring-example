RSpec.describe View::Account do
  ACCOUNT_VALIDATION_PHRASES = {
    name: {
      first_letter: 'Your name must not be empty and starts with first upcase letter'
    },
    login: {
      present: 'Login must present',
      longer: 'Login must be longer then 4 symbols',
      shorter: 'Login must be shorter then 20 symbols',
      exists: 'Such account is already exists'
    },
    password: {
      present: 'Password must present',
      longer: 'Password must be longer then 6 symbols',
      shorter: 'Password must be shorter then 30 symbols'
    },
    age: {
      length: 'Your Age must be greeter then 23 and lower then 90'
    }
  }.freeze

  let(:yes) { 'y' }
  let(:store_path) { 'spec/fixture/account.yml' }
  let(:correct_data) { { name: 'Andrey', login: 'Andrey', password: '123123123', age: 40 } }
  let(:incorrect_data) { { name: 'andery', login: 'a', password_p: '', password_l: 'a', password_s: 'a' * 50, age: 12 } }
  let(:account) { instance_double('Model::Account') }
  let(:described_instance) do
    allow(Manager::AccountManager).to receive(:new).and_return(Manager::AccountManager.new(file_path: store_path))
    described_class.new(previous_page: instance_double('Controller::Console', console: true))
  end

  before do
    allow(described_instance).to receive(:loop).and_yield
    # described_instance.instance_variable_set(:@account_manager, Manager::AccountManager.new(file_path: store_path))
  end

  describe 'account generation' do
    it 'create account if input correct data' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(correct_data[:name], correct_data[:age],
                                                                                   correct_data[:login], correct_data[:password])
      expect(described_instance.create).to be_a(Model::Account)
    end

    it 'load when input exist login and password account' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(correct_data[:login], correct_data[:password])
      expect(described_instance.load).to be_a(Model::Account)
    end

    it 'return false when try load account by incorrect login and password' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(incorrect_data[:login], incorrect_data[:password_l])
      expect(described_instance.load).to eq(false)
    end

    it 'create the first account' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(yes)
      expect(described_instance).to receive(:create)
      described_instance.create_the_first_account
    end

    it 'return to main menu the first account' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return('')

      expect(described_instance.create_the_first_account).to eq(true)
    end

    it 'destroy account' do
      expect(described_instance.instance_variable_get(:@account_manager)).to receive(:destroy)
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(yes)
      described_instance.destroy_account(account: account)
    end

    it ' not destroy account' do
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return('')
      expect(described_instance.destroy_account(account: account)).to be_nil
    end
  end

  describe 'validation ' do
    after do
      File.delete(store_path) if File.exist?(store_path)
    end

    it ' not create account if input incorrect name data' do
      error = ACCOUNT_VALIDATION_PHRASES[:name][:first_letter]
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(incorrect_data[:name], correct_data[:age],
                                                                                   correct_data[:login], correct_data[:password])
      expect { described_instance.create }.to output(/#{error}/).to_stdout
      described_instance.create
    end

    it ' not create account if input incorrect age data' do
      error = ACCOUNT_VALIDATION_PHRASES[:age][:length]
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(correct_data[:name], incorrect_data[:age],
                                                                                   correct_data[:login], correct_data[:password])
      expect { described_instance.create }.to output(/#{error}/).to_stdout
      described_instance.create
    end

    it ' not create account if input incorrect password data' do
      error = ACCOUNT_VALIDATION_PHRASES[:password][:longer]
      allow(loop)
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(correct_data[:name], correct_data[:age],
                                                                                   correct_data[:login], incorrect_data[:password_l])
      expect { described_instance.create }.to output(/#{error}/).to_stdout
      described_instance.create
    end

    it ' not create account if input incorrect password data' do
      error = ACCOUNT_VALIDATION_PHRASES[:password][:shorter]
      allow(loop)
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(correct_data[:name], correct_data[:age],
                                                                                   correct_data[:login], incorrect_data[:password_s])
      expect { described_instance.create }.to output(/#{error}/).to_stdout
      described_instance.create
    end

    it ' not create account if input incorrect password data' do
      error = ACCOUNT_VALIDATION_PHRASES[:password][:present]
      allow(loop)
      allow(described_instance).to receive_message_chain(:gets, :chomp).and_return(correct_data[:name], correct_data[:age],
                                                                                   correct_data[:login], incorrect_data[:password_p])
      expect { described_instance.create }.to output(/#{error}/).to_stdout
      described_instance.create
    end
  end
end
