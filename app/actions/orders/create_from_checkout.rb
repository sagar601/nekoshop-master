class Orders::CreateFromCheckout

  def initialize user:, money_service: MoneyService.new, mailer: MailerService.new, checkout_repo: CheckoutRepository.new
    @user = user
    @money_service = money_service
    @mailer = mailer
    @repo = checkout_repo
  end

  def call
    # TODO convert this to a sequence of worker jobs, with an optimistic success result and OOB error handling

    return empty_cart_error if cart.is_empty?

    charge_id = @money_service.charge_checkout checkout unless checkout.free?

    order = transaction do
      create_order!(charge_id).tap do
        checkout.destroy!
        checkout.cart.destroy!
      end
    end

    send_email order

    CreateOrderResult.new created?: true, order: order

  rescue MoneyService::CardRejectedError => e
    card_rejected_error
  end

  private

  def create_order! charge_id
    items = ::OrderItemFactory.new.from_cart_items cart.items

    order = Order.new customer: checkout.customer, items: items, address: checkout.address
    order.pay charge_id
    order.save!
    order
  end

  def send_email order
    @mailer.send_email OrderMailer, :new_order, @user, order
  end

  def empty_cart_error
    CreateOrderResult.new created?: false, error: :empty_cart
  end

  def card_rejected_error
    CreateOrderResult.new created?: false, error: :card_rejected
  end

  def checkout
    @checkout ||= @repo.of_customer(@user.customer) or raise Checkout::CheckoutExpiredError
  end

  def cart
    @cart ||= checkout.cart
  end

  def transaction &block
    ActiveRecord::Base.transaction &block
  end


  class CreateOrderResult < ActionResult

    def card_rejected?
      respond_to?(:error) && error == :card_rejected
    end

  end

end