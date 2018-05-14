Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    # Display sample data
    get "/page_view", to: "page_view#index"

    post "/page_view", to: "page_view#fetch"
  end
end
