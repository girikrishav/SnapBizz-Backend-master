class StoreCustomers
  include Interactor
  def perform
    match = {
      :number   => /^(\d+\W|[a-z]+)?(\d+)([a-z]?)\b/io,
      :street   => /(?:\b(?:\d+\w*|[a-z'-]+)\s*)+/io,
      :city     => /(?:\b[a-z][a-z'-]+\s*)+/io,
      :zip      => /\b(\d{6})(?:-(\d{4}))?\b/o,
      :at       => /\s(at|@|and|&)\s/io,
      :po_box => /\b[P|p]*(OST|ost)*\.*\s*[O|o|0]*(ffice|FFICE)*\.*\s*[B|b][O|o|0][X|x]\b/
    }

    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      Customer.create(store_id: store_id, name: row_data["customerName"], phone: row_data["customerPhoneNumber"], address1: row_data["customerAddress"], 
        address2: row_data[""], city: row_data[""], state: row_data[""], zip: (row_data["customerAddress"][match[:zip]]), tablet_db_id: row_data["customerId"])
    end
  end
end
