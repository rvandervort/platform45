class CreatePlatform45Games < ActiveRecord::Migration
  def change
    create_table :platform45_games do |t|
      t.string :game_id

      t.timestamps
    end
  end
end
