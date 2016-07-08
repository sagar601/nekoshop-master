class Cart::Items::Create

  def initialize user:, params:, vc_repo: ::VirtualCatRepository.new
    @user = user
    @params = params
    @vc_repo = vc_repo
  end

  def call
    return unavailable_error unless virtual_cat.available?

    item = transaction do
      item = cart.items.find_or_initialize_by virtual_cat_id: virtual_cat.id
      item.quantity += 1

      item.save!
      item
    end

    ActionResult.new created?: true, item: item
  end

  private

  def cart
    @cart ||= @user.customer.cart
  end

  def virtual_cat
    @virtual_cat ||= @vc_repo.find @params[:item][:virtual_cat_id]
  end

  def unavailable_error
    ActionResult.new created?: false, error: :cat_not_available
  end

  def transaction &block
    ActiveRecord::Base.transaction &block
  end

end