class Checkout::Create

  def initialize user:, scheduler: WorkerService.new, money_service: MoneyService.new
    @user = user
    @scheduler = scheduler
    @money_service = money_service
  end

  def call
    return success_result customer.checkout unless customer.checkout.nil?
    return empty_cart_error if customer.cart.is_empty?

    transaction do
      return insufficient_stock_error unless customer.cart.in_stock?

      customer.ensure_prepared_for_money! @money_service

      checkout = customer.create_checkout(cart: customer.cart)
      stock_reserve = reserve_stock! checkout
      schedule_cancellation checkout, stock_reserve

      success_result checkout
    end
  end

  private

  def reserve_stock! checkout
    checkout.cart.items.map do |item|
      vcat = item.virtual_cat

      vcat.stock -= item.quantity
      vcat.save!

      [vcat.id, item.quantity]
    end
  end

  def schedule_cancellation checkout, stock_reserve
    @scheduler.do_later ::CheckoutExpirationJob, checkout, stock_reserve, wait: 15.minutes
  end

  def customer
    @customer ||= @user.customer
  end

  def success_result checkout
    ActionResult.new created?: true, checkout: checkout
  end

  def empty_cart_error
    ActionResult.new created?: false, error: :cannot_checkout_empty_cart
  end

  def insufficient_stock_error
    ActionResult.new created?: false, error: :not_enough_stock
  end

  def transaction &block
    ActiveRecord::Base.transaction &block
  end

end