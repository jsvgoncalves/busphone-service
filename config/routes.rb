BusphoneService::Application.routes.draw do
  resources :tickets, defaults: {format: :json}

  # resources :users, defaults: {format: :json}

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'pages#index', defaults: {format: :json}

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'login/:email/:pw' => 'users#login'
  #get 'users/:id/buy/:ticket_type/:amount/t/:token' => 'users#buyTickets', defaults: {format: :json}
  get 'users/:id/buy/:nt1/:nt2/:nt3/t/:token' => 'users#buyTickets', defaults: {format: :json}
  get 'users/:id/use/:ticket/t/:token' => 'users#useTicket', defaults: {format: :json}
  get 'users/:id/tickets/t/:token' => 'users#getUserTickets', defaults: {format: :json}
  get 'users/:id/tickets/:ticket_type/t/:token' => 'users#getUserTicketsByType', defaults: {format: :json}
  get 'users/:id/t/:token' => 'users#show', defaults: {format: :json}
  get 'users/create/:name/:email/:pw' => 'users#create', defaults: {format: :json}
  get 'info' => 'users#info'

  # get all busline:
  get 'bus/lines/' => 'bus#all_lines', defaults: {format: :json}
  # assigns the :bus_id to the :line:
  get 'bus/login/:bus_id/:line' => 'bus#login', defaults: {format: :json}
  # get all tickets validated in this bus in the last hour
  get 'bus/validate/:bus_id/:ticket_id/:user_id' => 'bus#validate', defaults: {format: :json}
  # for bus creation (admin)
  get 'bus/create/:line_number' => 'bus#create', defaults: {format: :json}

  get 'bus/b/:line_number/' => 'bus#all_tickets', defaults: {format: :json} # gets all tickets from a bus
  #### get 'gadget/login/:id' => 'bus#create', defaults: {format: :json}

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
