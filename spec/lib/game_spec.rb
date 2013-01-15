require 'spec_helper.rb'

class DummyPlacementStrategy < PlacementStrategies::Base
  def self.place(board, ships); end;
end

describe Game do
  let(:game) { Game.new({board_size: 4})}

  describe ".initialize" do
    it "creates my board" do
      game.instance_variable_get(:@my_board).should be_instance_of(Board)
    end
    it "creates the opponent's board" do
      game.instance_variable_get(:@opponent_board).should be_instance_of(Board)
    end

    it "sets the default placement strategy" do
      Game.new(board_size: 4).placement_strategy.should == PlacementStrategies::DefaultStrategy
    end

    it "sets the passed-in placement strategy" do
      g = Game.new(board_size: 4, placement_strategy: DummyPlacementStrategy)
      g.placement_strategy.should == DummyPlacementStrategy
    end

    it "places the pieces on my board using the placement strategy supplied" do
      Game.any_instance.should_receive(:place_my_ships)
      Game.new(board_size: 4, placement_strategy: DummyPlacementStrategy)
    end

    it "places the pieces on my board using the default, if none specified" do
      Game.any_instance.should_receive(:place_my_ships)
      Game.new(board_size: 4)
    end
  end

  describe ".place_my_ships" do
    it "delegates to the placement strategy" do
      pending "not ready to implement this yet"
    end
  end
end

