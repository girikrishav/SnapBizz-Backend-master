class RetailerSignUp
  include Interactor

  def perform
    retailer = Retailer.find_by_phone(context["phone"])
    if retailer
      store = retailer.store
      store.update_attributes(context["store_attributes"].except(:device_attributes))
      device = store.device
      device.update_attributes({device_id: context["store_attributes"]["device_attributes"][:device_id], store_id: store.id.to_s})
      context[:retailer] = retailer
      context[:response_code] = 301
    else
      retailer = Retailer.create(context) 
      if retailer.errors.any?
        fail!(errors: retailer.errors.messages)
      else
        context[:retailer] = retailer
        context[:response_code] = 200
      end
    end
  end
end
