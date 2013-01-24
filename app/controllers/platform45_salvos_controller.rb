class Platform45SalvosController < ApplicationController
  def create
    @response = FireSalvoService.new.process(params[:platform45_game_id], params[:x], params[:y])

    render json: @response.to_json
  end
end
