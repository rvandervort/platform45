require 'spec_helper'

describe Platform45SalvosController do
  describe "POST /create" do
    let(:game) { Platform45Game.new }

    before :each do
      FireSalvoService.any_instance.stub(:process).and_return({"test" => "value"})
      game.stub(:id).and_return(12)
    end

    it "Fires a salvo using the service" do
      FireSalvoService.any_instance.should_receive(:process).with(game.id.to_s, nil, nil)
      post :create, { format: 'json', platform45_game_id: game.id }
    end

    it "renders the result of FireSalvoService as JSON" do
      post :create, { format: 'json', platform45_game_id: game.id }
      response.body == {"test" => "value"}.to_json
    end
  end
end
