module Manager
  class TaxManager
    TAX_TYPES = {
      usual: {
        withdraw: [0.05, 0],
        put: [0.04, 0],
        send: [0.88, 0]
      },
      capitalist: {
        withdraw: [0.02, 0],
        put: [0, 10],
        send: [0, 1]
      },
      virtual: {
        withdraw: [0, 20],
        put: [0.1, 0],
        send: [0, 1]
      }
    }.freeze
    def self.create(card_type:)
      Model::Tax.new(transaction_types: TAX_TYPES[card_type.to_sym])
    end
  end
end
