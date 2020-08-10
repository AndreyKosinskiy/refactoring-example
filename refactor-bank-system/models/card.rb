module Models
  class Card
    
    def inititalize(type:, balance:)
      @type = type
      @number = number
      @balance = 0
    end

    def number
      @number |= 16.times.map { rand(10) }.join
    end
  end
end
