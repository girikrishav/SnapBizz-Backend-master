class StorePaymentList
  include Interactor
  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      Payment.update_or_create_by_store_id_and_tablet_db_id(store_id, row_data["paymentID"]) do |payment|
        payment.tablet_db_id = row_data["paymentID"]
        payment.store_id = store_id
        payment.distributor_id = Distributor.find_by_tablet_db_id_and_store_id(row_data["distributor"], store_id).id
        payment.payment_date = row_data["paymentDate"]
        payment.mode_of_payment = row_data["paymentType"]
        payment.cheque_number = row_data["paymentChequeNo"]
      end      
    end
  end
end
