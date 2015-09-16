IndovinaZOO::Application.routes.draw do
    
  get "game/home"
  root "game#home"
  post "/settings" => "game#settings", as: :settings
  get "/settings" => "game#error"
  post "/quiz/:id" => "game#quiz"
  get "/quiz/:id" => "game#error"
  post "/result" => "game#result"
  get "/result" => "game#error"
  get "ranks/top5"
  post "ranks/create"
  post "/animali" => "animals#index", as: :animali
         
  resources :animals
  
  resources :quizzes

  post "/quizzes/set_animal_ids"
     
  devise_for :admin_users, controllers: { sessions: "admin_users/sessions", registrations: "admin_users/registrations" }
  
  devise_scope :admin_user do
	get "/admin_users/home", to: "admin_users/sessions#home", as: "admin_user_session_home"
  end
  
  get "/*all" => "game#home"
  post "/*all" => "game#home"
        
end
