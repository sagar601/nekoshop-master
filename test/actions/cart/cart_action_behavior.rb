module CartActionBehavior
  extend Minitest::Spec::DSL

  it 'retrieves an existing cart from a user' do
    user = User.create! email: Faker::Internet.email, password: 'password'
    cart = user.customer.cart
    cart.save!

    result = build_action(user: user).call
    result.cart.must_equal cart

    user.destroy!
  end

  it 'returns an empty cart for users who do not have one yet' do
    users = [User.new, User::Guest.new, User::Admin.new]

    users.each do |user|
      result = build_action(user: user).call

      result.cart.must_be_kind_of Cart
      result.cart.is_empty?.must_equal true
    end
  end

  it 'returns the current customer checkout if available' do
    checkout = Checkout.new
    cart_repo = Monkey.new CartRepository, of_customer: Cart.new
    checkout_repo = Monkey.new CheckoutRepository, of_customer: checkout

    result = build_action(user: User.new, cart_repo: cart_repo, checkout_repo: checkout_repo).call

    result.checkout.must_equal checkout
  end

  it 'returns a new checkout with the current cart if no checkout currently exists' do
    cart = Cart.new
    cart_repo = Monkey.new CartRepository, of_customer: cart
    checkout_repo = Monkey.new CheckoutRepository, of_customer: nil

    result = build_action(user: User.new, cart_repo: cart_repo, checkout_repo: checkout_repo).call

    result.checkout.must_be_kind_of Checkout
    result.checkout.new_record?.must_equal true
    result.checkout.cart.must_equal cart
  end
end