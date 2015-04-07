class StorePurchaseOrderItemList
  include Interactor

  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      purchase_order = PurchaseOrder.find_by_tablet_db_id_and_store_id(row_data["orderId"], store_id)
      product = Product.find_by_barcode_and_store_id(row_data["productSkuCode"], store_id)
      PurchaseOrderProduct.create(purchase_order_id: purchase_order.id, store_id: store_id, product_id: product.id, quantity: row_data["orderProductToOrderQty"])
    end
  end
end
