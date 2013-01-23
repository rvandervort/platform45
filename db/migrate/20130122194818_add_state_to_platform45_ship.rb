class AddStateToPlatform45Ship < ActiveRecord::Migration
  def change
    add_column :platform45_ships, :state, :string, default: "active"
  end
end
