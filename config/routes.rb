StripeExample::Application.routes.draw do

  resources :webhooks

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  devise_for :users

  get '/signup/:plan' => 'plans#show',  as: 'signup'
  get '/plans/'       => 'plans#index', as: 'plans'

  resources :subscriptions do
    put :change_plan, :on => :member, as: 'change'
  end

  root to: 'welcome#index'

end
