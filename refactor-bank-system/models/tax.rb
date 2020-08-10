module Models
  class Tax
    def initialize(transaction_types:)
      @transaction_types = transaction_types
    end

    def calc(amount:, transaction_type:)
      amount * @transaction_types[transaction_type.to_sum][0] + @transaction_types[transaction_type.to_sum][1]
    end
  end
end
