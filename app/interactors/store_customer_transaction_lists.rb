class StoreCustomerTransactionLists
  include Interactor
  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      customer = Customer.find_by_tablet_db_id_and_store_id(row_data["customerId"], store_id)
      CustomerTransaction.create(date: row_data["transactionTimeStamp"], store_id: store_id, customer_id: (customer ? customer.id : 0), discount: row_data["totalDiscount"], 
        total_amount: row_data["totalAmount"], payment_mode: "cash", status: (row_data["isPaid"] ? "paid" : "delivery"), tablet_db_id: row_data["transactionId"])
    end
  end
end
