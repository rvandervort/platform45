class Platform45Game < ActiveRecord::Base
  attr_accessor :name, :email
  
  attr_accessible :game_id

  has_many :salvos, class_name: "Platform45Salvo"
  has_many :ships, class_name: "Platform45Ship"
end
