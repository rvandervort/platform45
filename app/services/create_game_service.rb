class CreateGameService < ServiceBase
  def intialize
  end

  def process(name, email)
    game = Platform45Game.new

    api_request = ::Platform45::APIRequest.new
    api_response = api_request.register(name, email)

    if api_response.success?
      game.game_id = api_response.game_id
      game.save

      # Generate and place ships
      g = Game.new({board_size: 10})
      g.place_my_ships.each do |placement|
        s = Platform45Ship.create({platform45_game_id: game.game_id, name: placement["name"], owner: "me", x: placement[:x], y: placement[:y], orientation: placement[:orientation]})

        # But also place their ship too
        s2 = s.dup
        s2.id = nil
        s2.owner = "them"
        s2.save
      end
      
      salvo_service = EnemySalvoProcessService.new
      salvo_service.process(game, api_response.coordinates[0].to_i, api_response.coordinates[1].to_i)

      game
    else
      ServiceResponse.new(api_response.error)
    end
  end
end
