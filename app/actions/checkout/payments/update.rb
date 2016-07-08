class Checkout::Payments::Update

  def initialize user:, params:, checkout_repo: CheckoutRepository.new, money_service: MoneyService.new
    @user = user
    @params = params
    @repo = checkout_repo
    @money_service = money_service
  end

  def call
    transaction do
      use_new_card! if use_new_card?

      return card_required_error if !checkout.free? && !checkout.has_payment_method?
      return success_result
    end
  end

  private

  def use_new_card!
    customer = checkout.customer
    new_card = CreditCard.new @params['card']

    if remember_card?
      new_card = @money_service.set_customer_default_card customer, new_card.token

      PaymentMethod::CustomerCardPaymentMethod.create! customer: customer, card: new_card
    else
      PaymentMethod::OneTimeCardPaymentMethod.create! checkout: checkout, card: new_card
    end
  end

  def use_new_card?
    @params['commit'] == 'use_new_card'
  end

  def remember_card?
    @params['remember_card']
  end

  def checkout
    @checkout ||= @repo.of_customer(@user.customer) or raise Checkout::CheckoutExpiredError
  end

  def success_result
    ActionResult.new updated?: true, checkout: checkout
  end

  def card_required_error
    ActionResult.new updated?: false, checkout: checkout, error: :card_required
  end

  def transaction &block
    ActiveRecord::Base.transaction &block
  end

end