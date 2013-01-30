require 'spec_helper.rb'

describe DefaultPlacementStrategy do
  let(:board) { Board.new(10) }
  let(:ships) {[Ship.new("Ship5",5), Ship.new("Ship3",3), Ship.new("Ship2", 2)]}
  let(:response) { DefaultPlacementStrategy.place(board, ships) }

  describe "#place(board, ships)" do
    it "places every ship" do
      response.count.should == ships.count
    end
    it "places every ship in the first column" do
      response.each do |placement|
        placement[:x].should == 0
      end
    end
    it "places every ship in horizontal orientation" do
      response.each do |placement|
        placement[:orientation].should == :horizontal
      end
    end
  end
end
