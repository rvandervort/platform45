class CreatePlatform45Ships < ActiveRecord::Migration
  def change
    create_table :platform45_ships do |t|
      t.integer :platform45_game_id
      t.string :owner
      t.integer :x
      t.integer :y
      t.string :orientation

      t.timestamps
    end
  end
end
