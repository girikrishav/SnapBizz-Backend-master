class ApplicationController < ActionController::API
  include Notifier
  # before_filter :authenticate!

  private
  def authenticate!
    result = AuthenticateDevice.perform(token: params[:access_token])
    if result.success?
      @current_device = result.device
      @my_store = result.device.store
    else
      render json: { status: 401, error: "Invalid Access Token"}
    end
  end
end