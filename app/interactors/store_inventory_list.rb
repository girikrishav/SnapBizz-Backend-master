class StoreInventoryList
  include Interactor
  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      store_product = Product.find_by_barcode_and_store_id(row_data["productSkuCode"], store_id)
      unless store_product
        product = Product.find_by_barcode(row_data["productSkuCode"])
        global_product_brand = product.brand
        global_product_company = (global_product_brand.company rescue nil)
        store_company = (Company.find_by_name_and_store_id(global_product_company.name, store_id) rescue nil)
        store_brand = Brand.find_by_name_and_company_id_and_store_id((global_product_brand.name.strip rescue nil), store_company, store_id)
        store_product = product.dup
        store_product.brand_id = store_brand
        store_product.store_id = store_id
        store_product.save!
      end
      Inventory.update_or_create_by_barcode_and_store_id(row_data["productSkuCode"], store_id) do |inventory|
        inventory.store_id = store_id
        inventory.product_id = store_product.id
        inventory.barcode = row_data["productSkuCode"]
        inventory.mrp = store_product.mrp
        inventory.in_stock_quantity = row_data["quantity"]
        inventory.purchase_price = row_data["purchasePrice"]
        inventory.sale_price = row_data["salesPrice"]
        inventory.tax_rate = row_data["taxRate"]
        inventory.unit_type = row_data["unitType"]
        inventory.is_offer = row_data["isOffer"]
        inventory.tag = row_data["tag"]
      end
    end
  end
end
