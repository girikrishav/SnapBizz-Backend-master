class V1::RetailersController < ApplicationController

  skip_filter :authenticate!
  def index
    @retailers = Retailer.all
    render json: @retailers
  end

  def show
    @retailer = Retailer.find(params[:id])

    render json: @retailer
  end

  def create
    parameter = retailer_params
    parameter["store_attributes"].merge!({device_attributes: {device_id: params[:device_id]}})
    retailer = RetailerSignUp.perform(parameter)
    
    if retailer.success?
      access_token = GenerateAccessToken.perform(api_key: retailer.retailer.store.device.api_key)
      render json: {responseCode: retailer.response_code, responseMessage: "success", response: { api_key: retailer.retailer.store.device.api_key, store_id: retailer.retailer.store.id, retailer_id: retailer.retailer.id,  access_token: access_token.access_token, expiry_time: access_token.expiry   } }
    else
      render json: {responseCode: 406, responseMessage: "failure", response: { errors: retailer.errors}}
    end
  end

  def update
    @retailer = Retailer.find(params[:id])
    if @retailer.update(retailer_params)
      render json: {responseCode: 200, responseMessage: "success", response: { rretailer: @retailer}}
    else
      render json: {responseCode: 406, responseMessage: "failure", response: { errors: @retailer.errors}}
    end
  end

  def destroy
    @retailer = Retailer.find(params[:id])
    @retailer.destroy
    head :no_content
  end

  private

  def retailer_params
    params.require(:retailer).permit(:name, :phone, :email, store_attributes: [:tin, :name, :address1, :address2, :city, :state, :zip])
  end
end