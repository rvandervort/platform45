BattleshipAlgorithm::Application.routes.draw do
  get "main/main"

  root :to => 'main#main'
end
