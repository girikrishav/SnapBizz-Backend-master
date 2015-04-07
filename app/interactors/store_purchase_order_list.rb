class StorePurchaseOrderList
  include Interactor

  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      distributor = Distributor.find_by_tablet_db_id(row_data["distributorId"])
      PurchaseOrder.create(date: row_data["orderDate"], store_id: store_id, bill_amount: row_data["orderTotalAmount"], 
        status: row_data["orderStatus"], distributor_id: distributor.id, tablet_db_id: row_data["orderNumber"])
    end
  end
end
