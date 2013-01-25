require 'spec_helper.rb'

describe CreateGameService do
  let(:service) { CreateGameService.new }

  describe ".process(name, email)" do
    let(:name) { "name"}
    let(:email) { "email@email.com" }
    let(:request) { stub("Platform45::APIRequest") }
    let(:api_response) { stub("api_response", code: "200", body: '{"id": "1234", "x": "2", "y": "5"}') }
    let(:response) { Platform45::APIResponse.new(request, api_response, nil) }
    let(:game) { stub "Platform45Game", game_id: "1234", id: 12 }
    let(:ship_placements){(1..7).map { |i|  {x: i, y: i, name: "Ship#{i}", orientation: :horizontal}}}
    let(:dummy_ship) { Platform45Ship.new }

    before :each do
      Platform45Game.stub(:new).and_return(game)
      Platform45Ship.any_instance.stub(:save)

      game.stub(:save)
      game.stub(:game_id=)
      game.stub_chain(:ships, :mine, :at).and_return([])
      EnemySalvoProcessService.stub(:process)      
      Platform45::APIRequest.stub(:new).and_return(request)
      request.stub(:register).and_return(response)
      response.stub(:game_id).and_return("1234")
    end

    it "generates a new Platform45Game for persistence" do
      Platform45Game.should_receive(:new)
      service.process name, email
    end

    it "calls the API to register a new game" do
      request.should_receive(:register).with(name, email).and_return(response)
      service.process name, email
    end

    context "on successful registration" do
      it "sets the game ID to the one returned by the API" do
        game.should_receive(:game_id=)
        service.process name, email
      end

      it "saves the game record" do
        game.should_receive(:save)
        service.process name, email
      end

      it "creates a new internal game" do
        service.process name, email
      end

      it "places the ships" do
        Game.any_instance.stub(:place_my_ships).and_return(ship_placements)
        Game.any_instance.should_receive(:place_my_ships)
        service.process name, email
      end

      it "processes the first fired salvo" do
        EnemySalvoProcessService.any_instance.should_receive(:process).with(game, 2, 5, nil)
        service.process name, email
      end


      it "returns the AR game object" do
        Platform45Game.unstub!(:new) # otherwise returns stub()
        service.process(name, email).should be_instance_of(Platform45Game)
      end
    end

    context "on failed registration" do
      before :each do
        response.stub(:success?).and_return(false)
      end
      it "returns an instance of ServiceResponse " do
        service.process(name, email).should be_instance_of(ServiceResponse)
      end
      it "returns an instance of ServiceResponse with errors populated" do
        response.stub(:error).and_return("Unknown error")

        service_response = service.process(name, email)
        service_response.errors.any?.should be_true
      end

    end
  end
end
