class DefaultPlacementStrategy < PlacementStrategyBase
  class << self
    def place(board, ships)
      ships.each_with_index.map { |ship, i|   {x: 0, y: i, name: ship.name, orientation: :horizontal } }
    end
  end
end
