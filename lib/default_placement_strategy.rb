require_relative './placement_strategy_base.rb'

module PlacementStrategies
  class DefaultStrategy < PlacementStrategies::Base
    class << self
      def place(board, ships)
      end
    end
  end
end