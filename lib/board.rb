class Board
  attr_reader :size, :hits

  def [](x,y)
    @board[[x,y]]
  end

  def []=(x,y, value)
    raise StandardError, "Must be of class Space" if value.class != Space
    @board[[x,y]] = value
  end

  def adjacent_spaces(x,y)
    spaces = []

    spaces << @board[[x - 1, y]]
    spaces << @board[[x + 1, y]]
    spaces << @board[[x, y - 1]]
    spaces << @board[[x, y + 1]]
    
    spaces.reject { |s| s.nil? }
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

  def unsunk_ships?
    @hits > 0
  end

  def will_fit?(ship, x, y, orientation = :horizontal)
    fits = true

    x_range, y_range = RangeCalculator.new.send(orientation, x, y, ship.size)

    each_space x_range, y_range do |x, y, space|
      if space.filled?
        unless unsunk_ships?
          fits = false
          break
        end
      end
    end

    fits
  end
end
