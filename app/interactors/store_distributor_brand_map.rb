class StoreDistributorBrandMap
  include Interactor

  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)
      distributor = Distributor.find_by_tablet_db_id_and_store_id(row_data["distributorId"], store_id)
      store_brand = Brand.find_by_tablet_db_id_and_store_id(row_data["brandId"], store_id)

      unless store_brand
        brand = Brand.find(row_data["brandId"])
        store_brand = brand.dup
        store_brand.store_id = store_id
        store_brand.save!
      end
      distributor = DistributorBrand.find_or_create_by(distributor_id: distributor.id, brand_id: store_brand.id, store_id: store_id)

      if store_brand.products.empty?
        store_company = store_brand.company
        global_company = Company.find_by_name_and_store_id(store_company.name, nil)
        global_brand = Brand.find_by_name_and_company_id_and_store_id(store_brand.name, global_company.id, nil)
        global_brand.products.each do |global_product|
          unless Product.find_by_barcode_and_store_id(global_product.barcode, store_id)
            store_product = global_product.dup
            store_product.brand_id = store_brand.id
            store_product.store_id = store_id
            store_product.save!
            DistributorProduct.find_or_create_by(distributor_id: distributor, product_id: store_product)
          end
        end
      else
        store_brand.products.each do |product|
          DistributorProduct.find_or_create_by(distributor_id: distributor, product_id: product)
        end  
      end
    end
  end
end