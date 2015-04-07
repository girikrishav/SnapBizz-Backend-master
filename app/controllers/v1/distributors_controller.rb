class V1::DistributorsController < ApplicationController
  def list_by_pincode
    result = ListDistributorsByPincode(pincode: params[:pincode])
    render json: result.distributors
  end
end
