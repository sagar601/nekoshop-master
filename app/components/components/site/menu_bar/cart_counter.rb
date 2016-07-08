class Components::Site::MenuBar::CartCounter

  def initialize cart:
    @cart = cart
  end

  attr_reader :cart
end