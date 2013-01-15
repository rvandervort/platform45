require 'spec_helper.rb'

describe Space do

  describe ".filled?" do
    let(:space) { Space.new(1,1) }

    it "returns true if the state is a miss" do
      space.instance_variable_set :@state, :miss
      space.filled?.should be_true
    end

    
  end

end