module Manager
  class CardManager
    CARD_TYPE = {
      usual: { type: 'usual', balance: 50 },
      capitalist: { type: 'capitalist', balance: 100 },
      virtual: { type: 'virtual', balance: 150 }
    }.freeze

    def self.create(type:)
      Model::Card.new(**CARD_TYPE[type.to_sym])
    end

    def self.destroy(account:, card_number:)
      account.card.delete_if { |card| card.number == card_number }
    end

    def self.show_cards(account:)
      account.card
    end

    def self.get_by_card_number(card_number:)
      all_cards = Manager::AccountManager.new.all_cards
      if all_cards.select { |card| card.number == card_number }.any?
        all_cards.select { |card| card.number == card_number }.first
      else
        false
      end
    end
  end
end
