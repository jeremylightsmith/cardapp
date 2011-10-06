Cardapp::Application.routes.draw do
  root :to => "group_patterns#show"
  
  resource :group_patterns
end
