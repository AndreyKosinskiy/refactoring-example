module View
  class Transaction
    def initialize(current_account:)
      @current_account = current_account
      @transaction_engine = Manager::TransactionManager.create(account: @current_account)
    end

    def withdraw_money
      puts 'Choose the card for withdrawing:'
      if @current_account.card.any?
        @current_account.card.each_with_index do |card, i|
          puts "- #{card.number}, #{card.type}, press #{i + 1}"
        end
        puts "press `exit` to exit\n"
        loop do
          answer = gets.chomp
          break if answer == 'exit'

          if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
            current_card = @current_account.card[answer&.to_i.to_i - 1]
            loop do
              puts 'Input the amount of money you want to withdraw'
              amount = gets.chomp
              if amount&.to_i.to_i > 0
                result = @transaction_engine.withdraw_money(amount: amount&.to_i.to_i, card: current_card)
                if result
                  puts "Money #{result[:amount]} withdrawed from #{current_card.number}. Money left: #{result[:money_left]}$. Tax: #{result[:tax_value]}$"
                  return
                else
                  puts "You don't have enough money on card for such operation"
                  return
                end
              else
                puts 'You must input correct amount of $'
                return
              end
            end
          else
            puts "You entered wrong number!\n"
            return
          end
        end
      else
        puts "There is no active cards!\n"
      end
    end

    def put_money
      puts 'Choose the card for putting:'

      if @current_account.card.any?
        @current_account.card.each_with_index do |c, i|
          puts "- #{c.number}, #{c.type}, press #{i + 1}"
        end
        puts "press `exit` to exit\n"
        loop do
          answer = gets.chomp
          break if answer == 'exit'

          if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
            current_card = @current_account.card[answer&.to_i.to_i - 1]
            loop do
              puts 'Input the amount of money you want to put on your card'
              amount = gets.chomp
              if amount&.to_i.to_i > 0
                result = @transaction_engine.put_money(amount: amount, card: current_card)
                if !result
                  puts 'Your tax is higher than input amount'
                  return
                else
                  puts "Money #{result[:amount]} was put on #{current_card.number}. Balance: #{result[:balance]}. Tax: #{result[:tax_value]}"
                  return
                end
              else
                puts 'You must input correct amount of money'
                return
              end
            end
          else
            puts "You entered wrong number!\n"
            return
          end
        end
      else
        puts "There is no active cards!\n"
      end
    end

    def send_money
      puts 'Choose the card for sending:'

      if @current_account.card.any?
        @current_account.card.each_with_index do |card, i|
          puts "- #{card.number}, #{card.type}, press #{i + 1}"
        end
        puts "press `exit` to exit\n"
        answer = gets.chomp
        exit if answer == 'exit'
        if answer&.to_i.to_i <= @current_account.card.length && answer&.to_i.to_i > 0
          sender_card = @current_account.card[answer&.to_i.to_i - 1]
        else
          puts 'Choose correct card'
          return
        end
      else
        puts "There is no active cards!\n"
        return
      end

      puts 'Enter the recipient card:'
      card_number = gets.chomp
      if card_number.length > 15 && card_number.length < 17
        recipient_card = Manager::CardManager.get_by_card_number(card_number: card_number)

        unless recipient_card
          puts "There is no card with number #{card_number}\n"
          return
        end
      else
        puts 'Please, input correct number of card'
        return
      end

      loop do
        puts 'Input the amount of money you want to withdraw'
        amount = gets.chomp
        if amount&.to_i.to_i > 0

          if !@transaction_engine.check_tax(amount: amount, card: sender_card, type: :send)
            puts "You don't have enough money on card for such operation"
          elsif !@transaction_engine.check_tax(amount: amount, card: recipient_card, type: :put)
            puts 'There is no enough money on sender card'
          else
            result = @transaction_engine.send_money(amount: amount, sender_card: sender_card, recipient_card: recipient_card)
            puts "Money #{result[:sender][:amount]}$ was put on #{recipient_card.number}. Balance: #{result[:recipient][:balance]}. Tax: #{result[:recipient][:tax]}$\n"
            puts "Money #{result[:sender][:amount]}$ was put on #{sender_card.number}. Balance: #{result[:sender][:balance]}. Tax: #{result[:sender][:tax]}$\n"
            break
          end
        else
          puts 'You entered wrong number!\n'
        end
      end
    end
  end
end
