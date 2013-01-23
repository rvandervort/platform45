class Platform45Salvo < ActiveRecord::Base
  attr_accessible :owner, :platform45_game_id, :state, :x, :y

  scope :mine, where(:owner => "me")
  scope :theirs, where(:owner => "them")
  scope :hits, where(:state => "hit")
  scope :misses, where(:state => "miss")
end
