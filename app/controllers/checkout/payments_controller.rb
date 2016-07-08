class Checkout::PaymentsController < Checkout::StepsController

  def edit
    @result = Checkout::Payments::Edit.new(user: current_or_guest_user).call
  end

  def update
    @result = Checkout::Payments::Update.new(user: current_or_guest_user, params: params.to_unsafe_h).call

    if @result.updated?
      redirect_to new_checkout_confirm_url
    else
      flash.now.alert = user_message @result.error
      render :edit
    end
  end

end