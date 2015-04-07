class GenerateAccessToken
  include Interactor

  def perform
    device = Device.where(api_key: context[:api_key]).first
    return(fail!) unless device
    auth = device.authentication || device.build_authentication
    auth.generate_access_token
    context[:access_token] = auth.access_token
    context[:expiry] = auth.expiry
  end
end
