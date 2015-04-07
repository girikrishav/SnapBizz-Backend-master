class SearchStores
  include Interactor

  def perform
    if context[:pincode]
      zip = context[:pincode]
    else
      zip = context[:request].location.postal_code
    end
    context[:stores] = Store.where(zip: zip)
  end
end
