module Manager
  class AccountManager
    attr_accessor :file_path
    DEFAULT_FILE_PATH = 'accounts.yml'.freeze
    DEFAULT_ACTIONS = { destroy: 'destroy' }.freeze
    def initialize(file_path: DEFAULT_FILE_PATH)
      @file_path = file_path
    end

    def create(name:, login:, password:, age:, card: [])
      new_instance = Model::Account.new(name: name, login: login, password: password, age: age, card: card)
      new_accounts = accounts << new_instance
      File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml }
      new_instance
    end

    def get_by_card_number(card_number:)
      if accounts.select { |account| account.card.map(&:number).include?(card_number) }
        accounts.select { |account| account.card.map(&:number).include?(card_number) }.first
      else
        false
      end
    end

    def destroy(account:)
      update(account: account, action: DEFAULT_ACTIONS[:destroy])
    end

    def load(login:, password:)
      if accounts.map { |a| { login: a.login, password: a.password } }.include?({ login: login, password: password })
        accounts.select { |a| login == a.login }.first
      else
        false
      end
    end

    def update(account:, action: '')
      new_accounts = []
      puts accounts
      accounts.each do |ac|
        if ac.login == account.login
          case action
          when DEFAULT_ACTIONS[:destroy] then next
          else new_accounts.push(account)
          end
        else
          new_accounts.push(ac)
        end
      end
      File.open(@file_path, 'w') { |f| f.write new_accounts.to_yaml }
    end

    def exists?(login)
      accounts.map(&:login).include? login
    end

    def store_empty?
      accounts.empty?
    end

    def all_cards
      accounts.map(&:card).flatten
    end

    private

    def accounts
      if File.exist?(@file_path)
        YAML.load_file(@file_path)
      else
        []
      end
    end
  end
end
