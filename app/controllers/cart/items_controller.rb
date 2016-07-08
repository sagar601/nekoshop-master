class Cart::ItemsController < ApplicationController

  def create
    result = Cart::Items::Create.new(user: current_or_guest_user, params: params).call

    if result.created?
      redirect_to cart_url, notice: user_message(:cat_added_to_cart, cat_name: result.item.name)
    else
      redirect_to :back, alert: user_message(result.error)
    end
  end

  def destroy
    @result = Cart::Items::Destroy.new(user: current_or_guest_user, item_id: params[:id]).call

    redirect_to cart_url, notice: removed_item_message(@result)
  end

  private

  def removed_item_message result
    return nil unless result.destroyed?
    user_message :removed_items_from_cart, item: @result.item.name
  end
end