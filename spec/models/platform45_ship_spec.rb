require 'spec_helper.rb'

describe Platform45Ship do
  let(:horizontal_ship)   { Platform45Ship.new({orientation: "vertical", x: 2, y: 2, name: "Carrier"}) }
  let(:vertical_ship)   { Platform45Ship.new({orientation: "horizontal", x: 2, y: 2, name: "Carrier"}) }

  describe "horizontal_intersection?(check_x, check_y)" do
    context "within range" do
      it "returns true" do
        horizontal_ship.horizontal_intersection?(5, 2).should be_true
      end
    end

    context "outside of range" do
      it "returns false, vertically" do
        horizontal_ship.horizontal_intersection?(5, 1).should be_false
      end

      it "returns false, horizontally" do
        horizontal_ship.horizontal_intersection?(1, 2).should be_false
      end
    end
  end

  describe "intersects?(check_x, check_y)" do
    it "returns false if neither x or y match the checked values" do
      horizontal_ship.intersects?(9, 3).should be_false
    end
    it "delegates to the horizontal directional checks" do
      horizontal_ship.should_receive(:horizontal_intersection?).with(3, 2)
      horizontal_ship.intersects?(3, 2)
    end
    it "delegates to the vertical directional checks" do
      horizontal_ship.should_receive(:vertical_intersection?).with(2, 8)
      horizontal_ship.intersects?(2, 8)
    end    
  end

  describe "vertical_intersection?(check_x, check_y)" do
    context "within range" do
      it "returns true" do
        vertical_ship.vertical_intersection?(2, 4).should be_true
      end
    end

    context "outside of range" do
      it "returns false, vertically" do
        vertical_ship.vertical_intersection?(8, 2).should be_false
      end

      it "returns false, horizontally" do
        vertical_ship.vertical_intersection?(1, 5).should be_false
      end
    end    
  end

end