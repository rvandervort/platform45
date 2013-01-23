class FireSalvoService
  def process(platform45_game_id, x = nil, y = nil)

    platform45_game = Platform45Game.find(platform45_game_id)

    board = Board.new(10)

    platform45_game.salvos.mine.each do |salvo|
      board.mark_space salvo.x, salvo.y, salvo.state.to_sym
    end

    # Subtract out open hits
    platform45_game.ships.theirs.each do |ship|
      board.hits -= ship.size if ship.sunk?
    end

    unsunk_ships = platform45_game.ships.theirs.reject(&:sunk?).map(&:to_internal_ship)

    guess = ProbabilityCalculator.new.next_guess(board, unsunk_ships)

    api_response = Platform45::APIRequest.new.nuke(platform45_game.game_id, guess[0], guess[1])


    if api_response.success?
      if api_response.won?
        {status: :ok, game_state: :iwon, msg: "I've won!", prize: api_response.prize }
      else
        normal_response(platform45_game, api_response, guess)
      end
    else
      {status: :error, msg: api_response.error}
    end
  end

  def normal_response(platform45_game, api_response, my_salvo_coordinates) 
    retval = {status: :ok, game_status: :active}


    retval[:my_fired_salvo] = { x: my_salvo_coordinates[0], y: my_salvo_coordinates[1], state: api_response.status }

    retval[:their_fired_salvo] = EnemySalvoProcessService.new.process(platform45_game, api_response.coordinates[0], api_response.coordinates[1])

    retval[:msg] = "I fired at #{my_salvo_coordinates} - #{api_response.status.upcase}. They fired at #{api_response.coordinates} - #{retval[:their_fired_salvo][:state].upcase}"
    retval[:sunk] = api_response.sunk

    Platform45Salvo.create({x: my_salvo_coordinates[0], y: my_salvo_coordinates[1], owner: "me", platform45_game_id: platform45_game.id, state: api_response.status })

    if api_response.sunk?
      if (ship = platform45_game.ships.theirs.active.where(:name => api_response.sunk).first)
        ship.state = "sunk"
        ship.save  
      end
    end


    retval
  end
end