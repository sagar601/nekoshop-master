class PaymentMethod::CustomerCardPaymentMethod < PaymentMethod

  validates :customer, presence: true

  def stripe_charge_params
    { customer: customer.external_id }
  end

end