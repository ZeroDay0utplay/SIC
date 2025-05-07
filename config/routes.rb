Rails.application.routes.draw do
  scope module: :web do
    devise_for :users,
      skip: [:sessions, :registrations, :password, :confirmations],
      controllers: {sessions: "users/sessions"}

    devise_scope :user do
      get "/login" => "users/sessions#new", :as => :new_user_session
      post "/login" => "users/sessions#create"
      delete "/logout" => "users/sessions#destroy", :as => :destroy_user_session
      get "/profile/edit" => "users/profile#edit", :as => :edit_profile
      patch "/profile" => "users/profile#update"
    end

    scope module: :superadmin do
      resources :companies, only: [:index] do
        member do
          get "switch-company", to: "companies#switch_company"
        end
        collection do
          get "switch-global", to: "companies#switch_global"
        end
      end
      resources :administrators, only: [:index]
    end

    resources :absences

    resources :boards do
      resources :column_items do
        resources :tasks do
          member do
            post :reorder
          end
        end
      end
    end

    namespace :plannings do
      root to: "punctuals#index"
      resources :punctuals
      resources :regulars, only: [:index, :edit, :update, :destroy] do
        get :manage_tasks_agents, on: :member
        post :update_tasks_agents, on: :member
      end
    end

    namespace :finances do
      get "/prestations", to: "commercials#get_prestations"
      get "/prestations/:id", to: "commercials#set_prestation"

      resources :quotes do
        collection do
          get "client-headings/:id", to: "quotes#client_headings"
          get "admin-details/:id", to: "quotes#admin_details"
          get "new-from-model/:source_id", to: "quotes#new_from_model", as: :new_from_model
          post :create_quote_contact
        end

        member do
          get :edit_informations
          put :update_informations
          get :edit_prestations
          put :update_prestations
          get :preview
          get :pdf, defaults: {format: "pdf"}
          post :create_quote_contact
        end
      end

      resources :bills
      resources :interventions, only: [:index, :show, :destroy] do
      end
    end

    get "needs/new/(:type)" => "needs#new", :as => :new_need
    get "needs/get_agents" => "needs#get_agents", :as => :new_need_get_agents
    get "needs/get_materials" => "needs#get_materials", :as => :new_need_get_materials
    get "needs/get_interventions/:id/:model" => "needs#get_interventions", :as => :get_interventions_need
    post "needs/create_punctual" => "needs#create_punctual", :as => :create_punctual_need
    post "needs/create_regular" => "needs#create_regular", :as => :create_regular_need

    namespace :settings do
      resources :companies do
        member do
          get "numberings", to: "companies#numberings"
          patch "numberings", to: "companies#update_numberings"

          get "bank", to: "companies#bank"
          patch "bank", to: "companies#update_bank"

          get "switch-company", to: "companies#switch_company"
        end
      end

      resources :mention_legals

      resources :headings do
        collection do
          get :modal_new
        end
      end

      resources :users do
        get "/new/:type" => "users#new"

        collection do
          get :agents
          get :administrators
        end

        member do
          get :confirm_activate
          patch :activate
        end
      end

      resources :clients do
        member do
          get :site_contact
        end
        collection do
          get :modal_new
        end
      end

      resources :skills do
        collection do
          get :check_name
        end
      end

      resources :regions

      resources :prestations do
        collection do
          get :modal_new
        end
      end

      resources :subcontractors do
        member do
          get :get_agents
          get :search_agents
          get :add_agents
          post :create_agent
          post :assign_agents_to_subcontractor
        end
      end

      resources :contacts do
        collection do
          get :search
          get :modal_new
        end
      end

      resources :email_models do
        collection do
          get :search
        end
      end

      resources :quotes_model do
        collection do
          get :index
        end
      end
    end

    get "settings", to: "settings#index", as: :settings_index
  end

  # API MOBILE
  namespace :api do
    namespace :v1 do
      devise_scope :user do
        post "login" => "sessions#create"
        delete "logout" => "sessions#destroy"
      end
      resources :user, only: [:show]
      resources :absences, only: [:index]
    end
  end

  root "home#index"
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
