module Blackjack
  module Hand
    class DealerHand < BaseHand
      def open_last_card
        @cards.last.open
        self
      end
    end
  end
end
