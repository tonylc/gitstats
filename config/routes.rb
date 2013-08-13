Gitstats::Application.routes.draw do
  match 'ratio' => 'home#ratio'
  root :to => 'home#index'
end
