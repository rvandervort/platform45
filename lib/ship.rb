class Ship
  attr_reader :size, :name

  def initialize(name, size)
    @name, @size = name, size
  end
end
