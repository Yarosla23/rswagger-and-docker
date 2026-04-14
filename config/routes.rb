Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
 namespace :api do
    namespace :v1 do
      resources :students, only: [ :create, :destroy ]

      resources :schools, only: [] do
        resources :classes, only: [ :index ] do
          resources :students, only: [ :index ], controller: "class_students"
        end
      end
    end
  end
end
