class Checkout::ConfirmsController < Checkout::StepsController

  def new
    @result = Checkout::Confirm::New.new(user: current_or_guest_user).call
  end

  def create
    result = Orders::CreateFromCheckout.new(user: current_or_guest_user).call

    if result.created?
      redirect_to orders_url, notice: user_message(:order_placed_successfully)
    elsif result.card_rejected?
      redirect_to edit_checkout_payment_url, alert: user_message(result.error)
    else
      flash.now.alert = user_message(result.error)
      render :new
    end
  end

end