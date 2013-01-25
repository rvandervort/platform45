class Platform45Game < ActiveRecord::Base
  attr_accessor :name, :email
  
  attr_accessible :game_id, :open_hit_counter

  has_many :salvos, class_name: "Platform45Salvo", dependent: :destroy
  has_many :ships, class_name: "Platform45Ship", dependent: :destroy
end
