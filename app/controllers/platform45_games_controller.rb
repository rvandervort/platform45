class Platform45GamesController < ApplicationController
  def new
    @game = Platform45Game.new
  end

  def create
    @game = CreateGameService.new.process(params[:platform45_game][:name], params[:platform45_game][:email])
  end
end
