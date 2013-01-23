require 'spec_helper.rb'

describe SalvoProcessService do
  let(:service) { SalvoProcessService.new }
  let(:game) { Platform45Game.new }
  let(:x) { 2 }
  let(:y) { 5 }


  describe ".mine" do
    context "on hit" do
      it "creates and saves a new Platform45Salvo with state = hit"
      it "increments the games open_hit_counter"
    end

    context "on miss" do
      it "creates and saves a new Platform45Salvo with state = miss"  
    end
  end

  describe ".process(game, salvo_owner, x, y)" do
    it "delegates to the :theirs method" do
      service.should_receive(:theirs).with(game, x, y)
      service.process game, :theirs, x, y
    end
    it "delegates to the :mine method" do
      service.should_receive(:mine).with(game, x, y)
      service.process game, :mine, x, y
    end    
  end

  describe ".theirs" do
    context "on hit" do
    end

    context "on miss" do
    end
  end

end