class CartRepository

  def of_customer customer, includes: [ items: [ virtual_cat: [ :cat ] ] ]
    Cart.includes(includes).find_by(customer_id: customer.id) || Cart.new(customer: customer)
  end

end