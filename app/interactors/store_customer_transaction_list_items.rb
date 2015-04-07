class StoreCustomerTransactionListItems
  include Interactor

  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      transaction = CustomerTransaction.find_by_tablet_db_id_and_store_id(row_data["transactionId"], store_id)
      store_product = Product.find_by_barcode_and_store_id(row_data["productSkuCode"], store_id)
      unless store_product
        product = Product.find_by_barcode(row_data["productSkuCode"])
        store_product = product.dup
        store_product.store_id = store_id
        store_product.save!
      end

      inventory = Inventory.find_by_store_id_and_product_id(store_id, store_product)
      quantity = ((['GM', 'ML'].include? row_data["billItemUnitType"].upcase) ? row_data["productSkuQuantity"]/1000 : row_data["productSkuQuantity"])
      CustomerTransactionProduct.create(store_id: store_id, quantity: quantity,
        sale_price: row_data["productSkuSalePrice"], customer_transaction_id: transaction.id,
        date: transaction.date,
        product_id: store_product.id, 
        bill_product_unit_type: (['GM', 'ML'].include? row_data["billItemUnitType"].upcase ? (row_data["billItemUnitType"].upcase == 'GM' ? 'KG' : 'LTR') : row_data["billItemUnitType"].upcase),
        line_item_total: row_data["productSkuQuantity"] * row_data["productSkuSalePrice"], 
        line_item_profit: ((row_data["productSkuQuantity"] * row_data["productSkuSalePrice"]) - (inventory.purchase_price * row_data["productSkuQuantity"])))
    end
  end
end