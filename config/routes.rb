Todolist::Application.routes.draw do

  namespace :api do
    resources :tasks
  end

end
