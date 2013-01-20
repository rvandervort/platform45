class Platform45Game < ActiveRecord::Base
  attr_accessor :name, :email
  
  attr_accessible :game_id
end
