class CheckoutsController < ApplicationController

  def create
    @result = Checkout::Create.new(user: current_or_guest_user).call

    if @result.created?
      redirect_to edit_checkout_address_url
    else
      redirect_to :back, alert: user_message(@result.error)
    end
  end

end