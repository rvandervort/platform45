class SalvoProcessService < ServiceBase
  def initialize
  end

  def mine(game, x, y)
    
  end

  def process(game, salvo_owner = :mine, x, y)
    self.send salvo_owner, game, x, y
  end

  def theirs(game, x, y)
  end
end