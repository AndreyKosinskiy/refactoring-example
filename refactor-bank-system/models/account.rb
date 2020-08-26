module Model
  class Account
    attr_accessor :login, :name, :card, :password
    def initialize(name:, login:, password:, age:, card: [])
      @name = name
      @login = login
      @password = password
      @age = age
      @card = card
    end

    def add_card(type:)
      @card.push(Manager::CardManager.create(type: type))
      save
    end

    def show_cards
      Manager::CardManager.show_cards(account: self)
    end

    def destroy_card(position:)
      Manager::CardManager.destroy(account: self, card_number: @card[position].number)
      save
    end

    def save
      Manager::AccountManager.new.update(account: self, action: '')
    end
  end
end
