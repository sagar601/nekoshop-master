class CartFactory

  def self.create! items: 0, checkout: false
    user = User.create! email: Faker::Internet.email, password: 'password'
    cart = user.customer.cart.tap &:save!

    items.times do |i|
      i = i + 1

      cat = Cat.create! name: Faker::Name.name, price: Money.new(i * 999)
      virtual_cat = VirtualCat.create! cat: cat, stock: (i * 2)

      cart.items << CartItem.new(quantity: i, virtual_cat: virtual_cat)
    end

    cart.customer.create_checkout(cart: cart) if checkout

    cart
  end

  def self.cleanup!
    Checkout.all.each &:destroy!
    User.all.each &:destroy!
    Cat.all.each &:destroy!
  end

end