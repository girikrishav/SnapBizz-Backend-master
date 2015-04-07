class StoreProductReceiveBatchList
  include Interactor
  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      ProductReceiveBatchList.update_or_create_by_store_id_and_tablet_db_id(store_id, row_data["slNo"]) do |product_receive_batch|
        product_receive_batch.store_id = store_id
        product_receive_batch.barcode = row_data["productSkuCode"]
        product_receive_batch.quantity = row_data["batchQty"]
        product_receive_batch.mrp = row_data["batchMrp"]
        product_receive_batch.purchase_price = row_data["batchPurchasePrice"]
        product_receive_batch.discount = row_data[""]
        product_receive_batch.date = row_data["batchTimeStamp"]
        product_receive_batch.purchase_order_id = PurchaseOrder.find_by_tablet_db_id_and_store_id(row_data["batchOrder"], store_id).id rescue nil
        product_receive_batch.available_quantity = row_data["batchAvailableQty"]
        product_receive_batch.tablet_db_id = row_data["slNo"]
      end      
    end
  end
end
