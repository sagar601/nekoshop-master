require_relative 'cart_factory'
require_relative 'address_factory'
require_relative 'credit_card_factory'

class CheckoutFactory

  def self.create! payment_method: :none, address: :none, free: false # TODO needs a tidy up
    cart = CartFactory.create! items: 1
    customer = cart.customer

    PaymentMethod::CustomerCardPaymentMethod.create! customer: customer, card: CreditCardFactory.build if payment_method == :customer

    cart.items.first.virtual_cat.cat.tap{ |cat| cat.price = Money.new(0); cat.save! } if free

    checkout_address = (address == :checkout ? AddressFactory.build : Address.new)

    Checkout.create! cart: cart, customer: customer, address: checkout_address
  end

  def self.cleanup!
    CartFactory.cleanup!
    Checkout.all.each &:destroy!
  end

end