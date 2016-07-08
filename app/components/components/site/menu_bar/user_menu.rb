class Components::Site::MenuBar::UserMenu

  def initialize context:, user:
    @context = context
    @user = user
  end

  attr_reader :user

  def links
    @links ||= build_links
  end

  private

  Item = Struct.new :text, :url, :options

  def build_links
    case @user
    when User::Admin then item_pool.slice :admin, :orders, :logout
    when User        then item_pool.slice :orders, :logout
    else                  item_pool.slice :logout
    end.values
  end

  def item_pool
    @item_pool ||= {
      admin: Item.new(@context.t('.admin_area'), @context.admin_dashboard_path, { class: link_classes('admin-link') }),
      orders: Item.new(@context.t('.view_orders'), @context.orders_path, { class: link_classes('orders-link') }),
      logout: Item.new(@context.t('.logout'), @context.destroy_user_session_path, { method: :delete, class: link_classes('sign-out-link') }),
    }
  end

  def link_classes unique_class
    "item Site-MenuBar-UserMenu_#{unique_class}"
  end

end