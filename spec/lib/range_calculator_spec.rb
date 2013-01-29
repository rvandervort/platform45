require 'spec_helper.rb'

describe RangeCalculator do
  let(:calculator) { RangeCalculator.new }

  describe ".horizontal(start_x, start_y, ship_size)" do
    it "returns the correct range" do
      x, y = calculator.horizontal(1,2,3)

      x.should == (1..3)
      y.should == 2
    end
  end

  describe ".vertical(start_x, start_y, ship_size)" do
    it "returns the correct range" do
      x, y = calculator.vertical(1,2,3)

      x.should == 1
      y.should == (2..4)    
    end
  end
end
