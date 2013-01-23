BattleshipAlgorithm::Application.routes.draw do
  resources :platform45_games do
    resources :platform45_salvos
  end


  get "main/main"

  root :to => 'main#main'
end
