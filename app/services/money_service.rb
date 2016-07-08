class MoneyService
  ::Stripe.api_key = ENV.fetch('STRIPE_SECRET_KEY')

  class CardRejectedError < ::RuntimeError; end

  def initialize logger: Rails.logger
    @logger = logger
  end

  def charge_checkout checkout
    customer = checkout.customer
    total = checkout.total

    charge_params = {
      amount: total.cents,
      currency: total.currency.iso_code,
      statement_descriptor: 'CatShop Order',
      description: checkout.summary
    }.merge! checkout.payment_method.stripe_charge_params

    @logger.info "MoneyService: charging customer #{customer.id} with #{total.format} for:\n#{checkout.summary}\nusing method:\n#{checkout.payment_method.inspect}"

    Stripe::Charge.create(charge_params).id

  rescue Stripe::CardError => e
    raise CardRejectedError
  end

  def create_customer customer
    Stripe::Customer.create(email: customer.user.email, metadata: { customer_id: customer.id }).id
  end

  def set_customer_default_card customer, cc_token
    stripe_customer = ::Stripe::Customer.retrieve customer.external_id
    stripe_customer.source = cc_token
    stripe_customer.save

    stripe_customer.cards.first.to_h.slice :brand, :last4, :exp_month, :exp_year

  rescue Stripe::CardError => e
    raise CardRejectedError
  end

end