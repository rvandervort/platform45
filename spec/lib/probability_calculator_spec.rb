require 'spec_helper.rb'

describe "ProbabilityCalculator" do
  let(:subject) { ProbabilityCalculator.new }
  let(:board) { Board.new(4) }
  let(:ship) { Ship.new("TestShip", 3) }

  describe ".calculate_single_ship(board, ship)" do
    let(:result) do
      h = Hash.new
      h[[1,1]] = 2
      h[[1,2]] = 3
      h[[1,3]] = 3
      h[[1,4]] = 2

      h[[2,1]] = 3
      h[[2,2]] = 4
      h[[2,3]] = 4
      h[[2,4]] = 3

      h[[3,1]] = 3
      h[[3,2]] = 4
      h[[3,3]] = 4
      h[[3,4]] = 3

      h[[4,1]] = 2
      h[[4,2]] = 3
      h[[4,3]] = 3
      h[[4,4]] = 2

      h
    end

    it "returns a hash" do
      subject.calculate_single_ship(board, ship).should be_instance_of(Hash)
    end

    it "returns the correct calculation, when no spaces are blocked" do
      result_matrix = subject.calculate_single_ship(board, ship)

      (1..4).each do |x|
        (1..4).each do |y|
          result_matrix[[x,y]].should == result[[x,y]]
        end
      end
    end
  end

  describe ".calculate_all_ships(board, ships[])" do
    let(:ships) {[
      Ship.new("Destroyer", 3),
      Ship.new("Patrol", 2)
    ]}
    let(:single_result) do
      h = Hash.new
      h[[1,1]] = 3
      h[[1,2]] = 7
      h[[2,1]] = 3
      h[[2,2]] = 7
      h
    end

    before :each do
      board.stub(:size).and_return(2)
      subject.stub(:calculate_single_ship).and_return(single_result)
    end

    it "returns a hash" do
      subject.calculate_all_ships(board, ships).should be_instance_of(Hash)
    end

    it "calculates probability for all ships[]" do
      subject.should_receive(:calculate_single_ship).twice
      subject.calculate_all_ships(board, ships)
    end

    it "sums up the individual probabilities" do
      result = subject.calculate_all_ships(board, ships)

      result[[1,1]].should == 6
      result[[1,2]].should == 14
    end
  end


  describe ".new_probability(board, matrix_cell, space)" do
    let(:space) { Space.new(1,1) }

    
    context "in hunt mode" do
      before :each do
        board.stub(:unsunk_ships?).and_return(false)
      end

      it "sets the cell to 1, if nil" do
        cell = nil
        subject.new_probability(board, cell, space).should == 1
      end

      it "adds 1 to the cell if not nil" do
        cell = 1
        subject.new_probability(board, cell, space).should == 2
      end      
    end

    context "in target mode" do
      let(:adjacent_spaces) { [Space.new(1,2,:hit)]}

      before :each do
        board.stub(:unsunk_ships?).and_return(true)
        board.stub(:adjacent_spaces).and_return(adjacent_spaces)
      end

      it "weights cells adjacent to a hit" do
        cell = 0
        subject.new_probability(board, cell, space).should == 20
      end

      it "does not weight cells not adjacent to a hit" do
        cell = 0
        adjacent_spaces.first.state = :miss
        
        subject.new_probability(board, cell, space).should == 1
      end
    end

    describe ".next_guess(board, ships)" do
      let(:probabilities) do
        h = Hash.new
        h[[1,1]] = 12
        h[[1,2]] = 3
        h[[2,1]] = 50
        h[[2,2]] = 7
        h
      end
      let(:ships) { [ship] }

      before :each do
        subject.stub(:calculate_all_ships).and_return(probabilities)
      end

      it "calculates the probability" do
        subject.should_receive(:calculate_all_ships).with(board, ships)
        subject.next_guess board, ships
      end

      it "returns the max of the calculated probabilities" do
        subject.next_guess(board, ships).should == [2, 1]
      end
    end
    

  end
end
