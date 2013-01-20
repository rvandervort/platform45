BattleshipAlgorithm::Application.routes.draw do
  resources :platform45_games


  get "main/main"

  root :to => 'main#main'
end
