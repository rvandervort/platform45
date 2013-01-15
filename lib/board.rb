class Board
  attr_reader :size, :hits

  def [](x,y)
    @board[[x,y]]
  end

  def []=(x,y, value)
    raise StandardError, "Must be of class Space" if value.class != Space
    @board[[x,y]] = value
  end

  def blocked?(x_range, y_range) 
    blocked = false
    each_space x_range, y_range do |x,y,space|
      break if (blocked = space.filled?) 
    end
    blocked
  end

  def initialize(size)
    @size = size
    @board = Hash.new
    @hits = 0

    (1..@size).each do |x|
      (1..@size).each { |y| @board[[x,y]] = Space.new(x,y) }
    end
  end

  
  def each_space(x = nil, y = nil, &block)
    
    # Range computation
    x_range = get_range(x)
    y_range = get_range(y)

    x_range.each do |x|
      y_range.each do |y|
        yield(x,y,@board[[x,y]])
      end
    end
  end

  def get_range(dimension) 
    if dimension.nil?
      (1..size)
    else
      if dimension.respond_to?(:count)
        dimension
      else
        [dimension]
      end
    end
  end

  def mark_space(x, y, state)
    @board[[x,y]].state = state
    if state == :hit
      @hits += 1
    end
  end

  def size
    @size
  end

  def will_fit?(ship, x, y, orientation = :horizontal)
  end
end
