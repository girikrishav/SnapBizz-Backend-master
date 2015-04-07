class V1::SyncController < ApplicationController
  def store_company_list
    respond StoreCompanyList.perform(params)
  end

  def store_brand_list
    respond StoreBrandList.perform(params)
  end

  def store_company_brand_map
    respond StoreCompanyBrandMap.perform(params)
  end

  def store_product_sku_list
    respond StoreProductSkus.perform(params)
  end

  def store_customer_transaction_list
    respond StoreCustomerTransactionLists.perform(params)
  end

  def store_customer_transaction_items_list
    respond StoreCustomerTransactionListItems.perform(params)
  end

  def store_customer_list
    respond StoreCustomers.perform(params)
  end

  def store_inventory_list
    respond StoreInventoryList.perform(params)
  end

  def store_distributor_list
    respond StoreDistributorList.perform(params)
  end

  def store_distributor_brand_map
    respond StoreDistributorBrandMap.perform(params)
  end

  def store_purchase_order_list
    respond StorePurchaseOrderList.perform(params)
  end

  def store_purchase_order_items_list
    respond StorePurchaseOrderItemList.perform(params)
  end

  def store_inventory_batches
    respond StoreProductReceiveBatchList.perform(params)
  end

  def store_payment_list
    respond StorePaymentList.perform(params)
  end

  def retrieve_company_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "companyList")
  end

  def retrieve_brand_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "brandList")
  end

  def retrieve_company_brand_map
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "productSkuList")
  end

  def retrieve_product_sku_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "companyBrandMap")
  end

  def retrieve_customer_transaction_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "transactionList")
  end

  def retrieve_customer_transaction_items_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "billItemList")
  end

  def retrieve_customer_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "customerList")
  end

  def retrieve_inventory_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "inventoryList")
  end

  def retrieve_distributor_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "distributorList")
  end

  def retrieve_distributor_brand_map
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "distributorBrandMap")
  end

  def retrieve_purchase_order_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "ordersList")
  end

  def retrieve_purchase_order_items_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "orderDetailsList")
  end

  def retrieve_inventory_batches
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "inventoryBatchList")
  end

  def retrieve_payment_list
    respond_retrieval StoreBackup.where(store_id: Digest::MD5::hexdigest(params[:store_id]), table: "paymentsList")
  end

  private
  def respond result
    if result.success?
      render json: success_response
    else
      render json: error_response
    end
  end

  def respond_retrieval store_backup
    if store_backup.count > 1
      render json: { responseCode: 200, responseMessage: "success", store_backup[0].table.to_sym => store_backup.collect(&:raw_data)} 
    else
      render json: { responseCode: 404, responseMessage: "not found"} 
    end
  end

  def success_response
    { responseCode: 200, responseMessage: "success" }
  end
  
  def error_response
    { responseCode: 406, responseMessage: "failure" }
  end
end