require 'spec_helper'

Deck = Blackjack::Deck

describe Deck do
  before do
    @deck = Deck.new
  end

  describe '#initialize' do
    it 'creates 52 cards' do
      expect(@deck.cards.count).to eq(52)
    end
  end

  describe '#shuffle' do
    it 'shuffles the cards' do
      cards_before_shuffle = @deck.cards.dup

      @deck.shuffle

      cards_after_shuffle = @deck.cards

      expect(cards_before_shuffle).not_to eq(cards_after_shuffle)
      expect(cards_before_shuffle.count).to eq(cards_after_shuffle.count)
    end
  end
end
