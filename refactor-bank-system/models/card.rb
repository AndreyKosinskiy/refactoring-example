module Model
  class Card
    attr_accessor :type, :balance, :number
    def initialize(type:, balance:)
      @type = type
      @balance = balance
      @number = generate_uniq_number
    end

    def generate_uniq_number
      16.times.map { rand(10) }.join
    end
  end
end
