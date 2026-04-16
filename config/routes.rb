Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :students, only: [ :create, :destroy ], param: :user_id

      get "schools/:school_id/classes", to: "school_classes#index"
      get "schools/:school_id/classes/:class_id/students", to: "students#index"
    end
  end
end
