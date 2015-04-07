class StoreDistributorList
  include Interactor

  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      Distributor.create(store_id: store_id, agency_name: row_data["agencyName"], salesman_name: row_data["salesmanName"], phone: row_data["phoneNumber"], 
        tin: row_data["tinNumber"], address1: row_data[""], address2: row_data[""], city: row_data["city"], state: row_data[""], zip: row_data["zip"], tablet_db_id: row_data["distributorId"])
    end
  end
end
