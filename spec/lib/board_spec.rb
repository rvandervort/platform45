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

  describe ".adjacent_spaces(x,y)" do
    it "returns correct spaces for an interior space" do
      spaces = board.adjacent_spaces(2,2)
      spaces.count.should == 4

      spaces.select { |s| s.x == 1 and s.y == 2}.count.should == 1
      spaces.select { |s| s.x == 2 and s.y == 1}.count.should == 1
      spaces.select { |s| s.x == 3 and s.y == 2}.count.should == 1
      spaces.select { |s| s.x == 2 and s.y == 3}.count.should == 1
    end

    it "returns correct spaces for the upper-right corner" do
      spaces = board.adjacent_spaces(4, 0)
      spaces.count.should == 2

      spaces.select { |s| s.x == 4 and s.y == 1}.count.should == 1
      spaces.select { |s| s.x == 3 and s.y == 0}.count.should == 1
      spaces.select { |s| s.x == 3 and s.y == 1}.should eq([])
    end

    it "returns correct spaces for the upper-left corner" do
      spaces = board.adjacent_spaces(0, 0)
      spaces.count.should == 2

      spaces.select { |s| s.x == 0 and s.y == 1}.count.should == 1
      spaces.select { |s| s.x == 1 and s.y == 0}.count.should == 1
      spaces.select { |s| s.x == 1 and s.y == 1}.should eq([])
    end

    it "returns correct spaces for the lower-left corner" do
      spaces = board.adjacent_spaces(0, 4)
      spaces.count.should == 2

      spaces.select { |s| s.x == 0 and s.y == 3}.count.should == 1
      spaces.select { |s| s.x == 1 and s.y == 4}.count.should == 1
      spaces.select { |s| s.x == 1 and s.y == 3}.should eq([])      
    end

    it "returns correct spaces for the lower-right corner" do
      spaces = board.adjacent_spaces(4, 4)
      spaces.count.should == 2

      spaces.select { |s| s.x == 3 and s.y == 4}.count.should == 1
      spaces.select { |s| s.x == 4 and s.y == 3}.count.should == 1
      spaces.select { |s| s.x == 3 and s.y == 3}.should eq([])            
    end    
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
      board.get_range(nil).should == (0..(board.size - 1))
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


  describe ".unsunk_ships?" do
    it "returns true if there are hits" do
      board.instance_variable_set :@hits, 1
      board.unsunk_ships?.should be_true
    end
    it "returns false if there are no hits" do
      board.instance_variable_set :@hits, 0
      board.unsunk_ships?.should be_false   
    end
  end

  shared_examples_for 'fitability' do
    it "returns true if all spaces are unvisited" do
      board.will_fit?(ship, 1,1, orientation).should be_true
    end

    it "returns true if a space is a hit, but there are un-sunk ships in play" do
      board.stub(:unsunk_ships?).and_return(true)
      board[test_x,test_y].stub(:state).and_return(:hit)
      board.will_fit?(ship, 1,1, orientation).should be_true
    end

    it "returns false if a space is a hit and there are no un-sunk ships in play" do
      board.stub(:unsunk_ships?).and_return(false)
      board[test_x,test_y].stub(:state).and_return(:hit)
      board.will_fit?(ship, 1,1, orientation).should be_false
    end

    it "returns false if a space is visited with a miss" do
      board[test_x,test_y].stub(:state).and_return(:miss)
      board.will_fit?(ship, 1,1, orientation).should be_false      
    end  
  end

  describe ".will_fit?(ship, start_x, start_y, orientation)" do
    let(:ship) { Ship.new("TestShip",2) }

    it_behaves_like 'fitability' do
      let(:orientation) { :horizontal }
      let(:test_x) { 2 }
      let(:test_y) { 1 }
    end

    it_behaves_like 'fitability' do
      let(:orientation) { :vertical }
      let(:test_x) { 1 }
      let(:test_y) { 2 }
    end
  end
end
