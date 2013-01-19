class Space
  attr_accessor :x,:y, :state

  # states = [:unvisited, :miss, :hit]

  def initialize(x,y, state = :unvisited)
    @x, @y, @state = x, y, state
  end

  def to_s
    "[#{@x}, #{@y}]"
  end

  def filled?
    [:miss, :hit].include?(state)
  end

  def hit?
    state == :hit
  end
end