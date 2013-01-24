object @game

attributes :id, :game_id, :open_hit_counter

node :my_ships do |game|
  game.ships.mine
end
node :my_salvos do |game|
  game.salvos.mine
end

node :their_ships do |game|
  game.salvos.theirs
end

node :their_salvos do |game|
  game.salvos.theirs
end
