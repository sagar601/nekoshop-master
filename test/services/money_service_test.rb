require 'test_helper'

require_relative '../test_support/factories/checkout_factory'

describe MoneyService, :vcr do # FIXME figure out why VCR is not working and unstub these tests

  it 'creates customers' do
    customer = Customer.new id: 123, user: User.new(email: 'a@b.c')

    Stripe::Customer.stub :create, OpenStruct.new(id: 'dummy_id') do
      MoneyService.new.create_customer(customer).must_equal 'dummy_id'
    end
  end

  it 'sets the default credit card on a customer' do
    dummy_customer = Struct.new :source, :cards do
      def save
        self.cards = [ CreditCard.new(brand: 'visa', last4: '1234', exp_month: 6, exp_year: 2016) ]
      end
    end.new

    Stripe::Customer.stub :retrieve, dummy_customer do
      card = MoneyService.new.set_customer_default_card Customer.new, 'dummy_token'

      card[:brand].must_equal 'visa'
      card[:last4].must_equal '1234'
      card[:exp_month].must_equal 6
      card[:exp_year].must_equal 2016
    end
  end

  describe '#charge_checkout' do

    before{ @checkout = CheckoutFactory.create! payment_method: :customer }

    let(:dummy_response) { OpenStruct.new id: 'dummy_charge_id' }

    it 'charges the amount of the checkout' do
      assert_charge = Proc.new do |charge_params|
        charge_params[:amount].must_equal @checkout.total.cents
        charge_params[:currency].must_equal @checkout.total.currency.iso_code
        dummy_response
      end

      Stripe::Charge.stub :create, assert_charge do
        MoneyService.new(logger: NullObject.new).charge_checkout @checkout
      end
    end

    it 'includes a short summary of the cart in the charge' do
      assert_description = Proc.new do |charge_params|
        charge_params[:description].must_equal @checkout.summary
        dummy_response
      end

      Stripe::Charge.stub :create, assert_description do
        MoneyService.new(logger: NullObject.new).charge_checkout @checkout
      end
    end

    it 'returns the charge id' do
      Stripe::Charge.stub :create, dummy_response do
        MoneyService.new(logger: NullObject.new).charge_checkout(@checkout).must_equal 'dummy_charge_id'
      end
    end

  end

end