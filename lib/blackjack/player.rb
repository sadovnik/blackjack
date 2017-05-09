module Blackjack
  class Player
    attr_reader :name, :bankroll

    def initialize(name, bankroll)
      @name = name
      @bankroll = bankroll
    end

    def can_afford?(amount)
      @bankroll >= amount
    end

    def withdraw(amount)
      @bankroll -= amount
    end

    def reward(amount)
      @bankroll += amount
    end
  end
end
