class StoreCompanyBrandMap
  include Interactor

  def perform
    store_id = Digest::MD5::hexdigest(context["storeId"])
    context.delete("storeId")
    context.delete("access_token")
    table_name = context.keys[0]
    context[table_name].each do |row_data|
      StoreBackup.create(store_id: store_id, raw_data: row_data.to_json, sync_date: DateTime.now.to_i, table: table_name)

      store_company = Company.find_by_tablet_db_id_and_store_id(row_data["companyId"], store_id)
      unless store_company
        company = Company.find(row_data["companyId"])
        store_company = company.dup
        store_company.store_id = store_id
        store_company.save!
      end      

      store_brand = Brand.find_by_tablet_db_id_and_store_id(row_data["brandId"], store_id)
      if store_brand
        store_brand.update_attributes(:company_id => store_company.id)
      else
        brand = Brand.find(row_data["brandId"])
        store_brand = brand.dup
        store_brand.company_id = store_company.id
        store_brand.store_id = store_id
        store_brand.save!
      end
    end
  end
end
