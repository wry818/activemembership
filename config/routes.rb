MembershipActivation::Application.routes.draw do
  
  # get ':id', to: 'webservice#index', as: :webservice_index
  # get ':id/login', to: 'webservice#login', as: :webservice_login
  # post 'ajax/initialreg', to: 'webservice#ajax_initialreg', as: :ajax_initialreg
  # post 'ajax/getproducttype', to: 'webservice#ajax_get_shopify_product_type', as: :ajax_get_shopify_product_type
  # post 'ajax/register', to: 'webservice#ajax_register', as: :ajax_register
  
  # post 'test/ajax/initialreg', to: 'test#ajax_initialreg_page', as: :test_ajax_initialreg
  # post 'test/ajax/login', to: 'test#ajax_login_page', as: :test_ajax_login
  # post 'test/ajax/register', to: 'test#ajax_register_page', as: :test_ajax_register
  # get 'test/ajax/edition', to: 'test#ajax_edition', as: :test_ajax_edition
  # get 'test/ajax/metafield', to: 'test#add_metafield_orders', as: :test_add_metafield_orders
  # get 'test/index', to: 'test#index', as: :test_index
  # get 'test/createorder', to: 'test#create_shopify_order', as: :test_create_shopify_order
  
  get 'checkout/:product_id/:plan', to: 'checkout#index', as: :checkout_index
  post 'checkout/continue', to: 'checkout#continue', as: :checkout_continue
  get 'checkout-payment/:product_id/:plan', to: 'checkout#payment', as: :checkout_payment
  post 'ajax/create_subscription', to: 'checkout#ajax_create_subscription', as: :ajax_create_subscription
  get 'checkout-thankyou/:order_id', to: 'checkout#thank_you', as: :checkout_thank_you
  
  # scope 'access_code_distribution' do
#       get 'add_note_attribute', to: 'access_code_distribution#add_note_attribute', as: :access_code_distribution_add_note_attribute
#       get ':id', to: 'access_code_distribution#index', as: :access_code_distribution_index
#   end
  
  get 'access_code_distribution/add_note_attribute', to: 'access_code_distribution#add_note_attribute', as: :access_code_distribution_add_note_attribute
  get 'access_code_distribution/:id', to: 'access_code_distribution#index', as: :access_code_distribution_index
  post 'ajax/get_access_code', to: 'access_code_distribution#get_access_code', as: :access_code_distribution_get_access_code
  post 'ajax/retrieve_existing_access_code', to: 'access_code_distribution#retrieve_existing_access_code', as: :access_code_distribution_retrieve_existing_access_code
  post 'ajax/update_existing_access_code', to: 'access_code_distribution#update_existing_access_code', as: :access_code_distribution_update_existing_access_code
  
  # post 'ajax/getproducttype', to: 'access_code_distribution#ajax_get_shopify_product_type', as: :ajax_get_shopify_product_type
  
  #get 'ajax/register', to: 'test#ajax_register', as: :test_ajax_register
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
