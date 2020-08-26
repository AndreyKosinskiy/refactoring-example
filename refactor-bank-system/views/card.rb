module View
  class Card
    def initialize(current_account:)
      @current_account = current_account
    end

    def create_card
      loop do
        puts 'You could create one of 3 card types'
        puts '- Usual card. 2% tax on card INCOME. 20$ tax on SENDING money from this card. 5% tax on WITHDRAWING money. For creation this card - press `usual`'
        puts '- Capitalist card. 10$ tax on card INCOME. 10% tax on SENDING money from this card. 4$ tax on WITHDRAWING money. For creation this card - press `capitalist`'
        puts '- Virtual card. 1$ tax on card INCOME. 1$ tax on SENDING money from this card. 12% tax on WITHDRAWING money. For creation this card - press `virtual`'
        puts '- For exit - press `exit`'

        command = gets.chomp
        if Manager::CardManager::CARD_TYPE.key?(command.to_sym)
          @current_account.card << Manager::CardManager.create(type: command)
          @current_account.save
          break
        else
          puts "Wrong card type. Try again!\n"
        end
      end
    end

    def destroy_card
      loop do
        if @current_account.card.any?
          puts 'If you want to delete:'
          @current_account.card.each_with_index do |c, i|
            puts "- #{c.number}, #{c.type}, press #{i + 1}"
          end
          puts "press `exit` to exit\n"
          answer = gets.chomp
          break if answer == 'exit'

          if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
            order = answer&.to_i.to_i - 1
            puts "Are you sure you want to delete #{@current_account.card[order].number}?[y/n]"
            answer_delete = gets.chomp
            if answer_delete == 'y'
              Manager::CardManager.destroy(account: @current_account, card_number: @current_account.card[order].number)
              break
            else
              return
            end
          else
            puts "You entered wrong number!\n"
          end
        else
          puts "There is no active cards!\n"
          break
        end
      end
    end

    def show_cards
      if @current_account.card.any?
        @current_account.card.each do |c|
          puts "- #{c.number}, #{c.type}"
        end
      else
        puts "There is no active cards!\n"
      end
    end
  end
end
