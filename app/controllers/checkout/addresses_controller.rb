class Checkout::AddressesController < Checkout::StepsController

  def edit
    @result = ::Checkout::AddressActions::Edit.new(user: current_or_guest_user).call
  end

  def update
    @result = ::Checkout::AddressActions::Update.new(user: current_or_guest_user, params: params.to_unsafe_h).call

    if @result.updated?
      redirect_to @result.checkout.free? ? new_checkout_confirm_url : edit_checkout_payment_url
    else
      render :edit
    end
  end

end