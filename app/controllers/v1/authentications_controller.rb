class V1::AuthenticationsController < ApplicationController
  skip_filter :authenticate!

  def get_access_token
    result = GenerateAccessToken.perform(api_key: params[:api_key])
    if result.success?
      render json: { access_token: result.access_token, expiry_time: result.expiry }
    else
      render json: { errors: { code: 401, message: "Authorization failed." }}
    end
  end
end
