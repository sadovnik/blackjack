require 'spec_helper'

Card = Blackjack::Card

describe Card do
  describe '#equal_by_rank?' do
    context 'true cases' do
      # first card rank, second card rank
      [
        2, 2,
        :jack, :jack,
        :jack, :queen,
        10, :king,
        :ace, :ace
      ].each_slice(2).each do |pair|
        it "returns true for #{ pair.first } + #{ pair.last }" do
          first_card = Card.new(pair.first, :spade)
          second_card = Card.new(pair.last, :spade)

          expect(first_card.equal_by_rank?(second_card)).to be true
        end
      end
    end

    context 'false cases' do
      # first card rank, second card rank
      [
        2, 3,
        9, :jack
      ].each_slice(2).each do |pair|
        it "returns false for #{ pair.first } + #{ pair.last }" do
          first_card = Card.new(pair.first, :spade)
          second_card = Card.new(pair.last, :spade)

          expect(first_card.equal_by_rank?(second_card)).to be false
        end
      end
    end
  end
end
