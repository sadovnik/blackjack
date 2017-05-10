require 'spec_helper'

Hand = Blackjack::Hand::BaseHand
Card = Blackjack::Card

describe Hand do
  describe '#value' do
    [
      # card ranks, expected value
      [ 2 ],                    2,
      [ 2, 10 ],                12,
      [ :jack ],                10,
      [ :queen ],               10,
      [ :king ],                10,
      [ :king, 9 ],             19,
      [ :ace ],                 11,
      [ :ace, :ace ],           12,
      [ :king, 9, :ace ],       20,
      [ :jack, :ace ],          21,
      [ 8, 2, :ace ],           21,
      [ 8, :ace, 2 ],           21,
      [ 8, :ace, 2, 5 ],        16,
      [ 8, :ace, 2, 5, :ace ],  17
    ].each_slice(2).each do |pair|
      card_ranks, expected_value = pair

      it "calculates #{ card_ranks.map(&:to_s).join(' + ') } set as #{ expected_value }" do
        cards = card_ranks.map { |rank| Card.new(rank, :spade) }
        hand = Hand.new(cards)

        expect(hand.value).to eq(expected_value)
      end
    end

    context 'with hidden cards' do
      it 'skips hidden cards' do
        hand = Hand.new([
          Card.new(:king, :spade, true),
          Card.new(8, :heart)
        ])

        expect(hand.value).to eq(8)
      end
    end
  end

  describe '#append' do
    let(:hand) { Hand.new }

    it 'appends card' do
      expect { hand.append(Card.new(:ace, :spade)) }.to \
        change { hand.cards.count }.by(1)
    end
  end

  describe '#<=>' do
    let(:busted_hand) { Hand.new(3.times.map { Card.new(:king, :spade) }) }
    let(:empty_hand) { Hand.new }
    let(:hand_with_a_card) { Hand.new([ Card.new(:ace, :spade) ]) }

    context 'one of the hands is busted' do
      context 'left hand if busted' do
        subject { busted_hand <=> empty_hand }
        it { should equal(-1) }
      end

      context 'right hand if busted' do
        subject { empty_hand <=> busted_hand }
        it { should equal(1) }
      end

      context 'both hands are busted' do
        subject { busted_hand.dup <=> busted_hand }
        it { should equal(0) }
      end
    end

    context 'none of the hands is busted' do
      context 'right hand if bigger' do
        subject { empty_hand <=> hand_with_a_card }
        it { should equal(-1) }
      end

      context 'left hand is bigger' do
        subject { hand_with_a_card <=> empty_hand }
        it { should equal(1) }
      end

      context 'equally valued hands' do
        subject { hand_with_a_card.dup <=> hand_with_a_card }
        it { should equal(0) }
      end
    end
  end
end
