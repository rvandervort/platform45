class Platform45GamesController < ApplicationController
  
  def create
    @game = CreateGameService.new.process(params[:platform45_game][:name], params[:platform45_game][:email], Rails.logger)

    if @game.errors.any?
      flash[:error] = @game.errors.first
      redirect_to new_platform45_game_url
    else
      redirect_to platform45_game_url(@game)
    end
  end

  def new
    @game = Platform45Game.new
  end

  def show
    @game = Platform45Game.find(params[:id])
  end
  
end
