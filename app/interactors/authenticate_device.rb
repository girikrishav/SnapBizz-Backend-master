class AuthenticateDevice
  include Interactor

  def perform
    auth = Authentication.where(access_token: context[:token]).first
    if auth && auth.valid_access_token?(context[:token])
      context[:device] = auth.device
    else
      fail!
    end
  end
end
