class Game
   attr_reader :my_board, :opponent_board, :my_ships, :opponent_ships, :placement_strategy

   def initialize(options = {})
     @my_board = Board.new(options[:board_size])
     @opponent_board = Board.new(options[:board_size])
     @placement_strategy = options.fetch(:placement_strategy, DefaultPlacementStrategy)
     
     @my_ships = options.fetch(:ships) {[
        Ship.new("Carrier", 5),
        Ship.new("Battleship", 4),
        Ship.new("Destroyer", 3),
        Ship.new("Submarine", 2),
        Ship.new("Submarine", 2),
        Ship.new("Patrol Boat", 1),
        Ship.new("Patrol Boat", 1)
     ]}

     @opponent_ships = @my_ships.map(&:dup)

     place_my_ships 
   end

   def place_my_ships
     placement_strategy.place my_board, my_ships
   end
end
