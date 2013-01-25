class CreateGameService < ServiceBase

  def failed_response(game, api_response)
    ServiceResponse.new(api_response.error)
  end

  def intialize
  end

  def process(name, email, logger = nil)
    game = Platform45Game.new

    api_response = ::Platform45::APIRequest.new.register(name, email)

    if logger
      logger.debug "API Response: #{api_response.inspect}"
    end

    api_response.success? ? successful_response(game, api_response) : failed_response(game, api_response)
  end

  def successful_response(game, api_response)
    game.game_id = api_response.game_id
    game.save

    # Generate and place ships
    g = Game.new({board_size: 10})
    g.place_my_ships.each do |placement|

      s = Platform45Ship.new({platform45_game_id: game.id, name: placement[:name], owner: "me", x: placement[:x], y: placement[:y], orientation: placement[:orientation]})   
      s.save

      # But also place their ship too
      s2 = s.dup
      s2.id = nil
      s2.owner = "them"
      s2.save
    end
    
    salvo_service = EnemySalvoProcessService.new
    salvo_service.process(game, api_response.coordinates[0].to_i, api_response.coordinates[1].to_i)

    game
  end

end
