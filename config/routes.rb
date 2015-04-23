Rails.application.routes.draw do
  
  # match all /new routes and 404
  # this has side effects of not allowing responders to be named 'new'
  get 'responders/new', to: 'application#not_found'

  resources :responders, param: :name, except: [:new, :destroy, :edit], defaults: {format: :json}
  
  resources :emergencies, param: :code, defaults: {format: :json}

  # handle all unmatched routes
  match '*unmatched_route', to: 'application#not_found', via: :all
end
