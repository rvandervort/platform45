class FireSalvoService

  def create_my_salvo(game_id, x, y, status)
    Platform45Salvo.create({x: x, y: y, owner: "me", platform45_game_id: game_id, state: status })
  end

  def increase_hit_count(platform45_game)
    platform45_game.open_hit_counter += 1
    platform45_game.save          
  end

  def process(platform45_game_id, x = nil, y = nil)

    platform45_game = Platform45Game.find(platform45_game_id)

    board = prepare_board(platform45_game)
    
    #puts "process|board = #{board.inspect}"

    x, y = *ProbabilityCalculator.new.next_guess(board, unsunk_ships(platform45_game)) unless (x && y)

    #puts "process|guess x,y = #{x}, #{y}"
    api_response = Platform45::APIRequest.new.nuke(platform45_game.game_id, x, y)


    if api_response.success?
      if api_response.won?
        {status: :ok, game_status: :iwon, msg: "I've won!", prize: api_response.prize }
      else
        normal_response(platform45_game, api_response, [x,y])
      end
    else
      {status: :error, msg: api_response.error}
    end
  end

  def normal_response(platform45_game, api_response, my_salvo_coordinates)
    my_x, my_y = *my_salvo_coordinates
    their_x, their_y = *(api_response.coordinates)

    retval = {
      status: :ok, 
      game_status: :active,
      my_fired_salvo: {
        x: my_x,
        y: my_y,
        state: api_response.status
      },
      their_fired_salvo: EnemySalvoProcessService.new.process(platform45_game, their_x, their_y),
      sunk: api_response.sunk
    }
    retval[:msg] = "I fired at #{my_salvo_coordinates} - #{api_response.status.upcase}. They fired at #{[their_x, their_y]} - #{retval[:their_fired_salvo][:state].upcase}"

    create_my_salvo platform45_game.id, my_x, my_y, api_response.status

    sunk_a_ship(platform45_game, api_response) if api_response.sunk?

    increase_hit_count(platform45_game) if api_response.hit? and !api_response.sunk?

    retval
  end

  def prepare_board(platform45_game)
    board = Board.new(10)

    platform45_game.salvos.mine.each do |salvo|
      board.mark_space salvo.x, salvo.y, salvo.state.to_sym
    end

    # Subtract out open hits
    platform45_game.ships.theirs.each do |ship|
      board.hits -= ship.size if ship.sunk?
    end    

    board
  end

  def sunk_a_ship(platform45_game, api_response)
    if (ship = platform45_game.ships.theirs.active.where(:name => api_response.sunk).first)
      platform45_game.open_hit_counter -= (ship.size - 1)
      platform45_game.save
    
      ship.state = "sunk"
      ship.save  
    end    
  end

  def unsunk_ships(platform45_game)
    platform45_game.ships.theirs.reject { |s| s.sunk? }.map { |s| s.to_internal_ship }
  end
end
