class PaymentMethod < ActiveRecord::Base

  belongs_to :customer, inverse_of: :payment_method
  belongs_to :checkout, inverse_of: :payment_method

  def card
    @card ||= CreditCard.new super
  end

  def card= attributes
    @card = CreditCard.new attributes
    super @card.attributes
  end

  def stripe_charge_params
    raise NotImplementedError
  end

end
