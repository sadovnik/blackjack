module Blackjack
  class Game
    module Errors
      class UnableToActionError < StandardError; end
    end

    MINIMUM_BET_SIZE = 10

    attr_reader :player_hands, :dealer_hand

    def initialize(player, bet, shoe = Shoe.new)
      @player = player
      @shoe = shoe

      @player.withdraw(bet)

      @player_hands = [ Hand::PlayerHand.new(player, bet, [ @shoe.take, @shoe.take ]) ]
      @dealer_hand = Hand::DealerHand.new([ @shoe.take, @shoe.take(open: false) ])

      @state = :initial

      check_on_blackjack
    end

    def over?
      @state == :over
    end

    def act(action, hand_index)
      raise Errors::UnableToAction.new('Game is over') if over?
      raise Errors::UnableToAction.new('Invalid action') unless valid_action?(action)

      hand = @player_hands[hand_index]

      raise Errors::UnableToAction.new('Unknown hand') if hand.nil?

      self.send(action, hand)

      if ready_to_finish?
        @state = :over

        unless all_hands_busted?
          @dealer_hand.open_last_card

          fill_dealer_hand_until_17

          @player_hands.each do |hand|
            if hand > @dealer_hand
              @player.reward(hand.bet * 2)
            else hand == @dealer_hand
              @player.reward(hand.bet)
            end
          end
        end
      end
    end

    private

    def all_hands_busted?
      @player_hands
        .map(&:busted?)
        .reduce { |product, is_busted| product && is_busted }
    end

    def fill_dealer_hand_until_17
      until @dealer_hand.value >= 17
        @dealer_hand << @shoe.take
      end
    end

    def ready_to_finish?
      !@player_hands
        .map(&:playable?)
        .reduce { |product, is_playable| product || is_playable }
    end

    def stand(hand)
      fail unless hand.can_stand?

      hand.stand
    end

    def hit(hand)
      fail unless hand.can_hit?

      hand.append(@shoe.take)
    end

    def double(hand)
      fail unless hand.can_double?

      @player.withdraw(hand.bet)
      hand.double_bet
      hand.append(@shoe.take)
      hand.stand unless hand.busted?
    end

    def split(hand)
      fail unless hand.can_split?

      @player_hands << hand.split(@shoe.take, @shoe.take)
      @player.withdraw(hand.bet)
    end

    def check_on_blackjack
      first_hand = @player_hands.first

      if first_hand.blackjack?
        @state = :over
        @player.reward(first_hand.bet * 1.5)
      end
    end

    def valid_action?(action)
      [ :hit, :stand, :double, :split ].include?(action)
    end
  end
end
