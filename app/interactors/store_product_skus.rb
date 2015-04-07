class StoreProductSkus
  include Interactor

  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      name = row_data["productSkuName"]
      barcode = row_data["productSkuCode"]
      mrp = row_data["produtSkuMrp"]
      base_quantity = row_data["productSkuBaseQuantity"]
      unit_type = row_data["productSkuUnits"]
      store_brand = Brand.find_by_tablet_db_id_and_store_id(row_data["skuBrandId"], store_id)
      unless store_brand
        brand = Brand.find(row_data["skuBrandId"])
        store_brand = brand.dup
        store_brand.store_id = store_id
        store_brand.tablet_db_id = row_data["skuBrandId"]
        store_brand.save!
      end
      category = Category.find(row_data["skuSubCategoryId"])
      
      product = Product.create(name: name, barcode: barcode, mrp: mrp, base_quantity: base_quantity, unit_type: unit_type, store_id: store_id, brand_id: store_brand.id, sub_category_id: category.id, category_id: category.parent_id)
      CompanyProduct.find_or_create_by(company_id: store_brand.company, product_id: product)
    end
  end
end