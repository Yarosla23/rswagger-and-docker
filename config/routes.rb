Rails.application.routes.draw do
  root to: redirect("/api-docs")

  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :students, only: %i[create destroy], param: :user_id

      resources :schools, only: [] do
        get "classes", to: "school_classes#index"
        get "classes/:class_id/students", to: "students#index"
      end
    end
  end
end
