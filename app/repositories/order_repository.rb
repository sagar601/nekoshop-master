class OrderRepository

  def most_recent_of_customer customer, includes: [ :items ], limit: 5
    Order.includes(includes).where(customer_id: customer.id).order(updated_at: :desc).limit(limit)
  end

end