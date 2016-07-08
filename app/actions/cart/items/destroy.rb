class Cart::Items::Destroy

  def initialize user:, item_id:, item_repo: CartItemRepository.new
    @user = user
    @item_id = item_id
    @item_repo = item_repo
  end

  def call
    item = @item_repo.in_user_cart @user, @item_id

    item.destroy! unless item.nil?

    ActionResult.new destroyed?: !item.nil?, item: item
  end
end