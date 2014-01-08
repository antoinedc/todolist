Todolist::Application.routes.draw do

  namespace :api, :defaults => {:format => 'json'} do
  	scope :module => :v1 do
    	resources :tasks, :except => [:new, :edit]
    	resources :users, :except => [:index, :new, :edit, :update, :destroy]
    	match 'users/me', :to => 'users#show', :via => [:get]
    	match 'users/login', :to => 'users#login', :via => [:post]
    end
  end
  root :to => 'pages#index'

end
