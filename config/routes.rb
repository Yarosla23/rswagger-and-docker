Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :students, only: [ :create, :destroy ]

      resources :schools, only: [] do
        resources :school_classes, path: "classes", only: :index do
          resources :students, only: :index
        end
      end
    end
  end
end
