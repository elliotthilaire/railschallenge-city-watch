Rails.application.routes.draw do
  # match /new routes and result in 404
  # this has side effects of not allowing responders and emergencies to be named 'new',
  # however it is still part of the spec.
  get 'responders/new', to: 'application#not_found'
  get 'emergencies/new', to: 'application#not_found'

  resources :responders, param: :name, except: [:new, :destroy, :edit], defaults: { format: :json }

  resources :emergencies, param: :code, except: [:new, :destroy, :edit], defaults: { format: :json }

  # handle all unmatched routes
  match '*unmatched_route', to: 'application#not_found', via: :all
end
