class StorePushOffer
  include Interactor

  def perform
    context["store_id"] = Digest::MD5::hexdigest(context["store_id"])
    push_offer = PushOffer.create(context)
  end
end
