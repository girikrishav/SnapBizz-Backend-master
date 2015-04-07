class V1::StoresController < ApplicationController
  skip_filter :authenticate!
  def search
    result = SearchStores.perform({ pincode: params[:pincode], request: request})
    render json: { status: :success, stores: result.stores}
  end
end