class V1::PushOffersController < ApplicationController
  # GET /push_offers
  # GET /push_offers.json
  def index
    @push_offers = PushOffer.all

    render json: @push_offers
  end

  # GET /push_offers/1
  # GET /push_offers/1.json
  def show
    @push_offer = PushOffer.find(params[:id])

    render json: @push_offer
  end

  # POST /push_offers
  # POST /push_offers.json
  def create
    push_offer = StorePushOffer.new(push_offer_params)

    if push_offer.success?
      SendSMSNotification.new(push_offer)
      render json: {responseCode: 200, responseMessage: "success"}
    else
      render json: {responseCode: 406, responseMessage: "failure", response: { errors: push_offer.errors}}
    end
  end

  # PATCH/PUT /push_offers/1
  # PATCH/PUT /push_offers/1.json
  def update
    @push_offer = PushOffer.find(params[:id])

    if @push_offer.update(params[:push_offer])
      head :no_content
    else
      render json: @push_offer.errors, status: :unprocessable_entity
    end
  end

  # DELETE /push_offers/1
  # DELETE /push_offers/1.json
  def destroy
    @push_offer = PushOffer.find(params[:id])
    @push_offer.destroy

    head :no_content
  end

  private
  def push_offer_params
    params.require(:offer).permit(:store_id, :purchase_type, :offer_type, :offer_value, :start_date, :end_date, :message)
  end
end
