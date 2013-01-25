require 'spec_helper.rb'

describe FireSalvoService do
  let(:service) { FireSalvoService.new }
  let(:platform45_game) { Platform45Game.new({game_id: "3214", open_hit_counter: 20}) }

  before :each do
    platform45_game.stub(:id).and_return(12)
    Platform45Game.stub(:find).and_return(platform45_game)
  end

  describe ".prepare_board(game)" do
    it "returns a instance of Board" do
      service.prepare_board(platform45_game).should be_instance_of(Board)
    end
  end

  describe ".process(platform45_game_id, x, y)" do
    let(:my_salvos) do
      (1..4).map { |i| Platform45Salvo.new({x: i, y: i, state: "hit" }) } 
    end

    let(:their_ships) do [ 
      Platform45Ship.new({state: "active", name: "Carrier"}),
      Platform45Ship.new({state: "sunk", name: "Destroyer" }),
      Platform45Ship.new({state: "active", name: "Submarine"})
    ]
    end
    let(:error_response) { stub("ErrorResponse", error: "Basic error text", success?: false) }
    let(:normal_response) { stub("NormalResponse", success?: true ) }

    before :each do
      platform45_game.stub_chain(:salvos, :mine).and_return(my_salvos)
      platform45_game.stub_chain(:ships, :theirs).and_return(their_ships)
      Platform45::APIRequest.any_instance.stub(:nuke).and_return(error_response)
      ProbabilityCalculator.any_instance.stub(:next_guess).and_return([3,8])
    end

    it "calculates the next space to fire at" do
      ProbabilityCalculator.any_instance.should_receive(:next_guess)
      service.process 12
    end

    it "contacts the API" do
      Platform45::APIRequest.any_instance.should_receive(:nuke).with("3214", 3, 8)
      service.process 12
    end

    context "on API error" do
      before :each do
        Platform45::APIRequest.any_instance.stub(:nuke).and_return(error_response)
      end

      it "returns hash with status = error" do
        response = service.process(12)
        response[:status].should == :error
      end

      it "returns a hash with the error message" do
        response = service.process(12)
        response[:msg].should == "Basic error text"
      end
    end

    context "on API won" do
      let(:won_response) { stub("WonResponse", success?: true, won?: true, prize: "Prize text", status: "hit" ) }
      
      before :each do
        Platform45::APIRequest.any_instance.stub(:nuke).and_return(won_response)
      end

      it "returns a hash with status = ok" do
        response = service.process(12)
        response[:status].should == :ok
      end

      it "returns a hash with game_state = iwon" do
        response = service.process(12)
        response[:game_state].should == :iwon
      end

      it "returns a hash with the prize" do
        response = service.process(12)
        response[:prize].should == "Prize text"
      end
    end

    # I know this should be in another describe block for .normal_response
    # I don't care right now.
    context "on normal status" do
      let(:normal_response) { stub("NormalResponse", success?: true, won?: false, status: "miss", hit?: true, coordinates: [9,9], sunk: "Destroyer", sunk?: true)}
      let(:their_salvo) {{x: 9, y: 9, state: "miss"}}
      let(:active_ship) { Platform45Ship.new({name: "Destroyer"}) }

      before :each do
        Platform45::APIRequest.any_instance.stub(:nuke).and_return(normal_response)
        EnemySalvoProcessService.any_instance.stub(:process).and_return(their_salvo)
        platform45_game.stub_chain(:ships, :theirs, :active, :where, :first).and_return(active_ship)
      end

      it "returns the status = ok" do
        service.process(12)[:status].should == :ok
      end

      it "returns the game_status = active" do
        service.process(12)[:game_status].should == :active
      end
      
      it "returns my_fired_salvo object with coordinates and state" do
        response = service.process(12)

        response.has_key?(:my_fired_salvo).should be_true

        response[:my_fired_salvo][:x].should == 3
        response[:my_fired_salvo][:y].should == 8
        response[:my_fired_salvo][:state].should == "miss"
      end

      it "delegates to the EnemySalvoProcessService" do
        EnemySalvoProcessService.any_instance.should_receive(:process).with(platform45_game, 9, 9)
        service.process(12)
      end

      it "returns their_fired_salvo object with coordinates and state" do
        response = service.process(12)

        response.has_key?(:their_fired_salvo).should be_true  

        response[:their_fired_salvo][:x].should == 9
        response[:their_fired_salvo][:y].should == 9        
        response[:their_fired_salvo][:state].should == "miss"
      end

      it "returns the message with mine and theirs coordinates" do
        response = service.process(12)

        response[:msg].should =~ (/\[3, 8\]/)
        response[:msg].should =~ (/\[9, 9\]/)
      end

      it "returns the name of a ship, if I sunk one" do
        service.process(12)[:sunk].should == "Destroyer"
      end

      it "increments the game's open_hit_counter if a ship is hit" do
        normal_response.stub(:sunk?).and_return(false)
        platform45_game.should_receive(:open_hit_counter=).with(21)
        service.process(12)
      end

      it "reduces the game's open_hit_counter if a ship is sunk" do
        platform45_game.should_receive(:open_hit_counter=).with(18)  # open hits (20) - (Destroyer length (3) - 1)
        service.process(12)
      end

      it "creates a new Platform45Salvo record with state, owned by me" do
        Platform45Salvo.should_receive(:create).with({x: 3, y: 8, owner: "me", platform45_game_id: 12, state: "miss"})
        service.process(12)
      end



      it "marks the ship as sunk, if API returns sunk" do
        active_ship.should_receive(:state=).with("sunk")
        active_ship.should_receive(:save)
        service.process(12)
      end 
    end
  end
end
