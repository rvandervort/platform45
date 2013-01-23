class CreatePlatform45Salvos < ActiveRecord::Migration
  def change
    create_table :platform45_salvos do |t|
      t.integer :platform45_game_id
      t.string :owner
      t.integer :x
      t.integer :y
      t.string :state

      t.timestamps
    end
  end
end
