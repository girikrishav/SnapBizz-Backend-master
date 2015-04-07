SnapBizzMultitenant::Application.routes.draw do
  resources :distributors do
    collection do
      get :list_by_pincode
    end
  end
  namespace :v1 do
    resources :app_updates, only: [] do
      collection do
        get :latest_apk_version
        get :download_apk
      end
    end
    resources :stores, only: [] do
      collection do
        get :search
      end
    end
    resources :reports, only: [] do
      get :stock_report, on: :collection
      get :stock_money, on: :collection      
    end
    resources :retailers
    resources :push_offers
    resources :sync, only: [] do
      collection do
        post :store_company_list
        post :store_brand_list
        post :store_company_brand_map
        post :store_product_sku_list
        post :store_customer_list     
        post :store_inventory_list
        post :store_customer_transaction_list
        post :store_customer_transaction_items_list
        post :store_distributor_list
        post :store_distributor_brand_map
        post :store_purchase_order_list
        post :store_purchase_order_items_list
        post :store_inventory_batches
        post :store_payment_list
        get :retrieve_company_list
        get :retrieve_brand_list
        get :retrieve_company_brand_map
        get :retrieve_product_sku_list
        get :retrieve_customer_transaction_list
        get :retrieve_customer_transaction_items_list
        get :retrieve_customer_list
        get :retrieve_inventory_list
        get :retrieve_distributor_list
        get :retrieve_distributor_brand_map
        get :retrieve_purchase_order_list
        get :retrieve_purchase_order_items_list
        get :retrieve_inventory_batches
        get :retrieve_payment_list
      end
    end

    resources :authentications, only: [] do
      post :get_access_token, on: :collection
    end
  end
end
