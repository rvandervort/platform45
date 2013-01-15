require 'spec_helper.rb'

describe Board do
  let (:board) { Board.new(5) }

  describe ".[]" do
    it "returns the value at the specified position" do
      value = "crummy"
      b = board.instance_variable_get(:@board)
      b[[1,3]] = value

      board[1,3].should == value
    end
  end

  describe ".[]=" do
    it "raises an error if the class is not Space" do
      expect { board[1,2] = 12 }.to raise_error
    end
    it "sets the space on the board if the class is Space" do
      space = Space.new(1,2)
      expect { board[1,2] = space }.to change { board[1,2] }.to(space)
    end
  end

  describe ".blocked?" do
    it "returns true if a space is filled"
  end

  describe ".each_space" do
    it "yields each space" do
      spaces = []
      board.each_space do |x, y, space|
        spaces << space
      end

      spaces.count.should == 25
    end

    it "yields each space within the range" do
      spaces = []
      board.each_space [1,2] do |x, y, space|
        spaces << space
      end

      spaces.count.should == 10
    end
  end


  describe ".get_range" do
    it "returns an array with length equal to the board's size for nil" do
      board.get_range(nil).should == (1..board.size)
    end
    it "returns an array for simple integers" do
      board.get_range(2).should == [2]
    end

    it "returns an the input array for an array" do
      board.get_range([1,2]).should == [1,2]
    end
  end

  describe ".initialize" do
    it "creates a board @size x @size big" do
      board.instance_variable_get(:@board).keys.count.should == 25
    end
  end

  describe ".mark_space(x,y,state)" do
    it "sets the state for the given space" do
      expect { board.mark_space(1,1,:hit) }.to change { board[1,1].state }.to(:hit)
      end
  end

  describe ".will_fit?(ship, start_x, start_y, orientation)" do
    it "returns true if all spaces are unvisited" 
    it "returns true if a space is a hit, but there are un-sunk ships in play"
    it "returns false if a space is a hit and there are no un-sunk ships in play"
    it "returns false if a space is visited with a miss"
  end
end
