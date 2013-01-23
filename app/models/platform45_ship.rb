class Platform45Ship < ActiveRecord::Base
  attr_accessible :orientation, :owner, :platform45_game_id, :x, :y, :name, :state

  scope :mine, where(:owner => "me")
  scope :theirs, where(:owner => "them")
  scope :active, where(:state => "active")
  scope :sunk, where(:state => "sunk")
  scope :at, lambda { |x,y| where("x = ? OR y = ?", x, y)}

  def horizontal_intersection?(check_x, check_y)
    (y == check_y) and (x..(x + size)).include?(check_x)
  end

  def intersects?(check_x, check_y)
    return false if (x != check_x and y != check_y)

    horizontal_intersection?(check_x, check_y) || vertical_intersection?(check_x, check_y)
  end

  def size
    SHIP_LENGTHS[name]
  end

  def sunk?
    state == "sunk"
  end

  def to_internal_ship
    Ship.new(name, size)
  end

  def vertical_intersection?(check_x, check_y)
    (x == check_x) and (y..(y + size)).include?(check_y)
  end


end
