require 'test_helper'

require_relative '../../test_support/factories/credit_card_factory'

describe Components::Checkout::PaymentMethod do

  let(:payment_method) { PaymentMethod.new card: CreditCardFactory.build }
  let(:component) { Components::Checkout::PaymentMethod.new method: payment_method }

  it 'has the card brand' do
    component.card_brand.must_equal payment_method.card.brand
  end

  it 'has the obfuscated card number' do
    component.card_number.match(/\d+/)[0].must_equal payment_method.card.last4
  end

  it 'has the card expiration date' do
    component.card_expiration_date.to_s.wont_be_empty
  end

  it 'can be configured to not wrap itself' do
    component.wrapper_classes.to_s.wont_be_empty

    component = Components::Checkout::PaymentMethod.new method: payment_method, wrapped: false
    component.wrapper_classes.to_s.must_be_empty
  end

  it 'has an optional title, blank by default' do
    component.title.to_s.must_be_empty

    component = Components::Checkout::PaymentMethod.new method: payment_method, title: 'lorem ipsum'
    component.title.to_s.must_include 'lorem ipsum'
  end

end