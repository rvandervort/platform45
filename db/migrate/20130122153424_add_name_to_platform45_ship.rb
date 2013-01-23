class AddNameToPlatform45Ship < ActiveRecord::Migration
  def change
    add_column :platform45_ships, :name, :string
  end
end
