class Cart::Update
  using Augmented::Procs
  using Augmented::Symbols

  def initialize user:, params:, cart_repo: CartRepository.new, checkout_repo: CheckoutRepository.new
    @user = user
    @params = params
    @cart_repo = cart_repo
    @checkout_repo = checkout_repo
  end

  def call
    errors = @params['items'].map &(parse_ints | find_item | assign_quantity | take_errors)

    ActionResult.new any_errors?: errors.flatten.any?, cart: cart, checkout: checkout
  end

  private

  def parse_ints
    -> ((item_id, attrs)) { [ item_id.to_i, attrs['quantity'].to_i ] }
  end

  def find_item
    -> ((item_id, quantity)) { [ cart.items.detect(null_item, &(:id.eq item_id)), quantity ] }
  end

  def assign_quantity
    -> ((item, quantity)) do
      if quantity.zero?
        remove item
      else
        item.quantity = quantity
        item.save if valid? item
      end

      item
    end
  end

  def take_errors
    -> (item) { item.errors.full_messages.to_a }
  end

  def valid? item
    ::ItemQuantityValidator.new.validate item
  end

  def remove item
    Cart::Items::Destroy.new(user: @user, item_id: item.id).call
  end

  def null_item
    VoidObject.new
  end

  def cart
    @cart ||= @cart_repo.of_customer @user.customer
  end

  def checkout
    @checkout ||= (@checkout_repo.of_customer(@user.customer) || Checkout.new(cart: cart))
  end

end