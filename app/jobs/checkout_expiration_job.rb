class CheckoutExpirationJob < ActiveJob::Base
  queue_as :default

  def perform checkout, stock_reserve
    checkout.expire!

    stock_reserve.each do |(virtual_cat_id, quantity)|
      virtual_cat = VirtualCat.find_by_id(virtual_cat_id) or next

      virtual_cat.stock += quantity
      virtual_cat.save!
    end
  end

  rescue_from(ActiveJob::DeserializationError) do
    # checkout was already destroyed - do nothing
  end

end
