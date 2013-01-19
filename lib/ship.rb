class Ship
  attr_reader :size

  def initialize(name, size)
    @name, @size = name, size
  end
end