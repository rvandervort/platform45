require 'spec_helper.rb'

describe EnemySalvoProcessService do
  let(:service) { EnemySalvoProcessService.new }
  let(:game) { Platform45Game.new({game_id: "1234", open_hit_counter: 2})}
  let(:x) { 2 }
  let(:y) { 2 }
  let(:state) { "hit" }
  let(:ships) { [Platform45Ship.new()] }

  before :each do
    game.stub(:id).and_return(12)
    ships.first.stub(:intersects?).and_return(true)
    game.stub_chain(:ships, :mine, :at).and_return(ships)
  end

  describe ".process(game, x, y)" do
    let(:response) { service.process(game, x, y) }

    it "checks whether the coordinates are a hit or miss" do
      ships.first.should_receive(:intersects?).with(x, y)
      response
    end

    it "creates a new Platform45Salvo record" do
      Platform45Salvo.should_receive(:create).with({platform45_game_id: 12, owner: "them", x: x, y: y, state: state })
      response
    end

    it "returns a hash with the coordinates and state" do
      response.should be_instance_of(Hash)
      response[:x].should == x
      response[:y].should == y
      response[:state].should == "hit"
    end
  end
end
