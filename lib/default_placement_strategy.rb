class DefaultPlacementStrategy < PlacementStrategyBase
  class << self
    def place(board, ships)
      i = 0

      ships.map { |ship|  i += 1; {x: 1, y: i, name: ship.name, orientation: :horizontal } }
    end
  end
end
