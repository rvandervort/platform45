class AddOpenHitCounterToPlatform45Game < ActiveRecord::Migration
  def change
    add_column :platform45_games, :open_hit_counter, :integer, default: 0
  end
end
