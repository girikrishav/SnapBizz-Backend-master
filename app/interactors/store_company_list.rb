class StoreCompanyList
  include Interactor

  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      Company.create(store_id: store_id, name: row_data["companyName"].upcase, tablet_db_id: row_data["companyId"])
    end
  end
end
