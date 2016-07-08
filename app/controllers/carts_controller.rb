class CartsController < ApplicationController

  def show
    @result = Cart::Show.new(user: current_or_guest_user).call
  end

  def edit
    @result = Cart::Edit.new(user: current_or_guest_user).call
  end

  def update
    @result = Cart::Update.new(user: current_or_guest_user, params: params.to_unsafe_h).call

    if @result.any_errors?
      render :edit
    else
      redirect_to cart_url, notice: user_message(:items_updated)
    end
  end

end