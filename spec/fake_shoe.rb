class FakeShoe
  def initialize(cards)
    @cards = cards
  end

  def take(open: true)
    card = @cards.pop
    open ? card.open : card
  end
end
