class PaymentMethod::OneTimeCardPaymentMethod < PaymentMethod

  validates :checkout, presence: true
  validate :card_has_token

  def stripe_charge_params
    { source: card.token }
  end

  private

  def card_has_token
    errors[:card] << 'must have token' if card.token.to_s.empty?
  end

end