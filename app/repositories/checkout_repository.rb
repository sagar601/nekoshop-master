class CheckoutRepository

  def of_customer customer, includes: [ cart: [ items: [ virtual_cat: [ :cat ] ] ] ]
    Checkout.includes(includes).find_by customer_id: customer.id
  end

  def of_customer! *args
    of_customer(*args) or raise ActiveRecord::RecordNotFound
  end

end