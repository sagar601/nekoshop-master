class Checkout::AddressActions::Update

  def initialize user:, params:, checkout_repo: CheckoutRepository.new
    @user = user
    @params = params
    @repo = checkout_repo
  end

  def call
    if valid_params?
      transaction do
        update_address!
        remember_address! if remember_address?
      end
    end

    ActionResult.new updated?: valid_params?, address: address_form, checkout: checkout
  end

  private

  def valid_params?
    @valid_params ||= address_form.validate address_params
  end

  def address_params
    @params['address']
  end

  def update_address!
    checkout.address = address_params
    checkout.save!
  end

  def remember_address!
    checkout.customer.address = address_params
    checkout.customer.save!
  end

  def remember_address?
    @params['remember_address']
  end

  def checkout
    @checkout ||= @repo.of_customer(@user.customer) or raise Checkout::CheckoutExpiredError
  end

  def address_form
    @form ||= ::CheckoutAddressForm.new checkout.address
  end

  def transaction &block
    ActiveRecord::Base.transaction &block
  end

end