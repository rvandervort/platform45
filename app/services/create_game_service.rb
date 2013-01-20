class CreateGameService < ServiceBase
  def intialize
  end

  def process(name, email)
    game = Platform45Game.new

    api_request = Platform45::APIRequest.new
    api_response = api_request.register(name, email)

    if api_response.success?
      game.game_id = api_response.game_id
      game.save

      salvo_service = SalvoProcessService.new
      salvo_service.process(game, :theirs, api_response.coordinates[0].to_i, api_response.coordinates[1].to_i)

      game
    else
      ServiceResponse.new(api_response.error)
    end
  end
end
