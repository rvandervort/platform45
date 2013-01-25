class ProbabilityCalculator

  def calculate_all_ships(board, ships)
    probabilities = ships.map { |ship| calculate_single_ship(board, ship) }

    result_matrix = Hash.new

    (1..board.size).each do |x|
      (1..board.size).each do |y|
        result_matrix[[x,y]] = probabilities.inject(0) { |v,m| v = v + m[[x,y]]  }
      end
    end
    result_matrix
  end

  
  def calculate_single_ship(board, ship)
    matrix = initial_matrix(board)

    probability = Proc.new { |x,y,space|  matrix[[x,y]] = new_probability(board, matrix[[x,y]], space) }

    # Horizontal
    (1..board.size).each do |start_y|
      (1..(board.size - ship.size + 1)).each do |start_x|
        if board.will_fit?(ship, start_x, start_y, :horizontal)
          board.each_space (start_x..(start_x + ship.size - 1)), start_y, &probability
        end
      end
    end

    # Vertical
    (1..board.size).each do |start_x|
      (1..(board.size - ship.size + 1)).each do |start_y|
        if board.will_fit?(ship, start_x, start_y, :vertical)
          board.each_space start_x, (start_y..(start_y + ship.size - 1)), &probability
        end
      end
    end
    
    matrix
  end

  def initial_matrix(board)
    matrix = Hash.new

    (1..board.size).each do |x|
      (1..board.size).each do |y|
        matrix[[x, y]] = 0 
      end
    end

    matrix
  end

  def new_probability(board, matrix_cell, space)
    if space.filled?
      addition = 0
    else
      addition = 1
      if board.unsunk_ships? 
        if board.adjacent_spaces(space.x, space.y).any? { |space| space.hit? } 
          addition = 20
        end
      end
    end

    matrix_cell + addition
  end

  def next_guess(board, unsunk_ships)
    calculate_all_ships(board, unsunk_ships).max_by {|k, v| v }.first
  end
end