class CheckoutAddressForm < Reform::Form

  property :name, validates: { presence: true }
  property :line1, validates: { presence: true }
  property :line2
  property :postal_code, validates: { presence: true }
  property :city, validates: { presence: true }
  property :country, validates: { country: true }
  property :phone, validates: { presence: true }

  def persisted?
    true
  end

end