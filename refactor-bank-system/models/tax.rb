module Model
  class Tax
    def initialize(transaction_types:)
      @transaction_types = transaction_types
    end

    def calc(amount:, transaction_type:)
      amount.to_i * (@transaction_types[transaction_type.to_sym][0]).to_f + (@transaction_types[transaction_type.to_sym][1]).to_i
    end
  end
end
