module Model
  class Transaction

    TRANSACTION_TYPES={
      withdraw:'withdraw',
      put:'put',
      send:'send'
    }

    def initialize(account:,tax_manager:)
      @account = account
      @tax_manager = tax_manager
    end

    def withdraw_money(amount:,card:)
      tax = @tax_manager.create(card.type)
      tax_value = tax.calc(amount:amount,transaction_type:TRANSACTION_TYPES[:withdraw])

      money_left = card.balance - amount - tax_value
      if money_left > 0
        current_card[:balance] = money_left
        @current_account.card[answer&.to_i.to_i - 1] = current_card
        Manager::AccountManager.update(account:account, action: '')
        return {money_left:money_left,amount:amount,tax_value:tax_balue}
      else
        return false
      end
    end

    def put_money(amount:,card:)
      tax = @tax_manager.create(card.type)
      tax_value = tax.calc(amount:amount,transaction_type:TRANSACTION_TYPES[:put])

      new_money_amount = card.balance + amount - tax_value
      if tax_value <= amount
        card.balance = new_money_amount
        Manager::AccountManager.new.update(account:account, action: '')
        return {money_left:new_money_amount,amount:amount,tax_value:tax_value}
      else
        return false
      end
    end

    def send_money(amount:,sender_card:,recipient_card:)
      tax = @tax_manager.create(sender_card.type)
      tax_value_sender = tax.calc(amount:amount,transaction_type:TRANSACTION_TYPES[:send])
      tax = @tax_manager.create(recipient_card.type)
      tax_value_recipient = tax.calc(amount:amount,transaction_type:TRANSACTION_TYPES[:put])

      sender_balance = sender_card.balance - amount - tax_value_sender
      recepient_balance = recipient_card.balance - amount - tax_value_recipient

      if sender_balance < 0
        puts "You don't have enough money on card for such operation"
      elsif tax_value_recipient >= amount
        puts 'There is no enough money on sender card'
      end

      sender_card.balance = sender_balance
      Manager::AccountManager.new.update(account:account, action: '')

      recipient_account = Manager::AccountManager.new.get_by_card_number(card_number:recipient_card.number)
      new_recipient_card = recipient_account.card.select{|card| card.number == recipient_card.number}.first
      new_recipient_card.balance = recepient_balance
      Manager::AccountManager.new.update(account:recipient_account, action: '')

      return { 
        sender:{amount:amount,balance:sender_balance,tax:tax_value_sender},
        recipient:{amount:amount,balance:recepient_balance,tax:tax_value_recipient}
      }
    end
  end
end