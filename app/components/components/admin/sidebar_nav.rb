class Components::Admin::SidebarNav
  include ComponentTranslationHelpers
  using Augmented::Symbols

  def initialize context:, active: :none
    @context = context
    @items = build_items
    highlight active
  end

  attr_reader :items

  private

  def build_items
    [
      OpenStruct.new(id: :dashboard, name: t('.dashboard'), link: @context.admin_dashboard_path, classes: ''),
      OpenStruct.new(id: :cats, name: t('.cats'), link: @context.admin_cats_path, classes: ''),
      OpenStruct.new(id: :stocks, name: t('.stocks'), link: @context.admin_stocks_path, classes: ''),
    ]
  end

  def highlight id
    active_item = @items.find &(:id.eq id)
    active_item.classes = 'active' unless active_item.nil?
  end

end