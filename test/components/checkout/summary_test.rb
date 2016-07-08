require 'test_helper'

describe Components::Checkout::Summary do

  let(:cart) { Monkey.new(Cart, count: 10, total: Money.new(100)) }

  let(:checkout) { Monkey.new(Checkout,
    total: Money.new(199),
    shipping_cost: Money.new(99),
    shipping_cost_determinable?: true,
    cart: cart,
  )}

  let(:summary) { Components::Checkout::Summary.new checkout: checkout }

  it "has the checkout's total cost" do
    summary.total.must_equal checkout.total
  end

  it "has the checkout's shipping cost" do
    summary.shipping_cost.must_equal checkout.shipping_cost
  end

  it 'shows the shipping cost only if it is currently determinable' do
    summary.show_shipping_cost?.must_equal true

    undetermined_summary = Components::Checkout::Summary.new checkout: Monkey.new(Checkout, shipping_cost_determinable?: false)
    undetermined_summary.show_shipping_cost?.must_equal false
  end

  it 'has the number of items in the shopping cart' do
    summary.number_of_items.must_equal checkout.cart.count
  end

  it 'has wrapper classes that can be ommited' do
    wrapped_summary = Components::Checkout::Summary.new checkout: nil
    wrapped_summary.wrapper_classes.to_s.wont_be_empty

    wrapperless_summmary = Components::Checkout::Summary.new checkout: nil, wrapped: false
    wrapperless_summmary.wrapper_classes.to_s.must_be_empty
  end

  describe 'item breakdown' do

    it 'renders by default' do
      summary.show_items?.must_equal true
    end

    it 'can be configured to not render the item breakdown' do
      itemless_summmary = Components::Checkout::Summary.new checkout: checkout, show_items: false
      itemless_summmary.show_items?.must_equal false
    end

  end

end