module Controller
  class Console
    def initialize
      @state = nil
      @view_account = View::Account.new(previous_page: self)
    end

    def console
      puts 'Hello, we are RubyG bank!'
      puts '- If you want to create account - press `create`'
      puts '- If you want to load account - press `load`'
      puts '- If you want to exit - press `exit`'
      command = gets.chomp

      case command
      when 'create' then @state = @view_account.create
      when 'load' then @state = @view_account.load
      else exit
      end
      MainMenu.new(current_account: @state, view_account: @view_account).main_menu
    end
  end

  class MainMenu
    COMMANDS_STRING = %w[SC CC DC PM WM SM DA exit].freeze
    def initialize(current_account:, view_account:)
      @current_account = current_account
      @view_account = view_account
      @view_card = View::Card.new(current_account: @current_account)
      @view_transaction = View::Transaction.new(current_account: @current_account)
    end

    def main_menu
      loop do
        puts "\nWelcome, #{@current_account.name}"
        puts 'If you want to:'
        puts '- show all cards - press SC'
        puts '- create card - press CC'
        puts '- destroy card - press DC'
        puts '- put money on card - press PM'
        puts '- withdraw money on card - press WM'
        puts '- send money to another card  - press SM'
        puts '- destroy account - press `DA`'
        puts '- exit from account - press `exit`'

        command = gets.chomp
        case command
        when 'SC' then @view_card.show_cards
        when 'CC' then @view_card.create_card
        when 'DC' then @view_card.destroy_card
        when 'PM' then @view_transaction.put_money
        when 'WM' then @view_transaction.withdraw_money
        when 'SM' then @view_transaction.send_money
        when 'DA' then @view_account.destroy_account(account: @current_account); exit
        when 'exit' then exit
        else puts "Wrong command. Try again!\n"
        end
      end
    end
  end
end
