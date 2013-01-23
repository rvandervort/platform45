require 'spec_helper.rb'

class DummyPlacementStrategy < PlacementStrategyBase
  def self.place(board, ships); end;
end

describe Game do
  let(:game) { Game.new({board_size: 4})}

  describe ".initialize" do
    it "creates my board" do
      game.instance_variable_get(:@my_board).should be_instance_of(Board)
    end

    it "sets the default placement strategy" do
      Game.new(board_size: 4).placement_strategy.should == DefaultPlacementStrategy
    end

    it "sets the passed-in placement strategy" do
      g = Game.new(board_size: 4, placement_strategy: DummyPlacementStrategy)
      g.placement_strategy.should == DummyPlacementStrategy
    end
  end

  describe ".place_my_ships" do
    it "delegates to the placement strategy" do
      DefaultPlacementStrategy.should_receive(:place)
      game.place_my_ships
    end
  end
end

