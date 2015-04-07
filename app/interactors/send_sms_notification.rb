require 'rubygems'
require 'twilio-ruby'
 
class SendSmsNotification
  include Interactor

  def perform
    store_id = context["store_id"]
    customers = Customer.where(store_id: store_id)

    # Get your Account Sid and Auth Token from twilio.com/user/account
    account_sid = 'ACe7663577392b213ecacd7c12bf0d3197'
    auth_token = '5d59f9f7de0b33e22a4157060d707d11'
    begin
      @client = Twilio::REST::Client.new account_sid, auth_token
       
      message = @client.account.sms.messages.create(:body => "SnapBizz Test SMS",
          :to => "+919663394311",     # Replace with your phone number
          :from => "+13082109335")   # Replace with your Twilio number
      puts message.sid
      rescue Twilio::REST::RequestError => e
        puts e.message
    end
  end
end
