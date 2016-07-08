class Checkout::AddressActions::Edit

  def initialize user:, checkout_repo: CheckoutRepository.new
    @user = user
    @repo = checkout_repo
  end

  def call
    ActionResult.new checkout: checkout, address: address_form
  end

  private

  def address_form
    ::CheckoutAddressForm.new checkout.address
  end

  def checkout
    @checkout ||= @repo.of_customer(@user.customer) or raise Checkout::CheckoutExpiredError
  end

end