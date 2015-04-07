require 'gcm'
# Project ID:  snapbizz-gcm  
# Project Number:  240809485804
# API Key: AIzaSyDf6Xe90UkdJ6-ztHstvC0BX37LzdiOxO4
# Kannan device token : APA91bFZ90wPUbX7wYqNHjWgjo2r2F5P9TcOQVRdcoLra3N42t0IJA3FpGvTQ2sq1d7GSj7U92kbvtyjvXPWWBRJ2H-S19xSqJ-BPNt_MBcMgBn0wB9kjWa6aYzQyehHUanyRQzj8T2UmBHOZ2GXWqu5YQZDjW3GrA
module Notifier

  def gcm
    @gcm ||= GCM.new("AIzaSyDf6Xe90UkdJ6-ztHstvC0BX37LzdiOxO4")
  end
  
  def notify(device_token, device_type='android', msg = { :alert => "You have a new message" })
    gcm.send_notification([device_token], {:data=> msg})
  end

  def notify_user(opts={})
    user = db_find_one('thrill.users', {_id: db_id(opts["user_id"])})
    sender = opts["sender_id"].blank? ? "" : db_find_one('thrill.users', {_id: db_id(opts["sender_id"]) })
    alert = opts["alert"] || "You have a message"
    msg = { :alert => alert, :type => opts["type"] }
    if sender.present?
      msg.merge!( { :user_name => sender['name'], :user_id => sender['_id'].to_s })
    end
    notify(user["device_token"], user["device_type"], msg)
  end

end