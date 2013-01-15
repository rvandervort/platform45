class ProbabilityCalculator

  def calculate_all_ships(board, ships)
    probabilities = ships.map { |ship| calculate_single_ship(board, ship) }

    result_matrix = Hash.new

    (1..board.size).each do |x|
      (1..board.size).each do |y|
        result_matrix[[x,y]] = probabilities.inject(0) { |v,m| v = v + m[[x,y]] }
      end
    end
    result_matrix
  end

  
  def calculate_single_ship(board, ship)
     matrix = Hash.new
     

     # By rows
    (1..board.size).each do |start_y|
      (1..(board.size - ship.size + 1)).each do |start_x|
        if board.will_fit?(ship, start_x, start_y, :horizontal)
          board.each_space (start_x..(start_x + ship.size - 1)), start_y do |x, y, space|
            matrix[[x,y]] = new_probability(matrix[[x,y]], space)
          end
        end
      end
    end 

    matrix
  end

  def new_probability(matrix_cell, space)
    (matrix_cell.nil?) ? 1 : matrix_cell + 1
  end
end
