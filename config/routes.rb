StripeExample::Application.routes.draw do

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  get '/signup/:plan' => 'plans#show',  as: 'signup'
  get '/plans/'       => 'plans#index', as: 'plans'

  resources :subscriptions

  root to: 'welcome#index'

end
