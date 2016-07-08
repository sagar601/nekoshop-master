class Components::Cart::ItemsTable
  REMOVE_MESSAGE_KEY = self.name.underscore.tr('/','.') + '.are_you_sure_you_want_to_remove'

  def initialize context:, cart:, edit: false
    @context = context
    @cart = cart
    @edit = edit
  end

  def to_partial_path
    self.class.name.underscore + (@edit ? '_edit' : '')
  end

  def items
    @items ||= @cart.items.map &ItemDecorator.method(:new).curry(2)[@context]
  end

  class ItemDecorator < SimpleDelegator

    def initialize context, item
      @context = context
      super item
    end

    def options
      variations.join ' | '
    end

    def subtotal
      super.format
    end

    def unit_price
      super.format
    end

    def errors_cell
      messages = errors.full_messages

      if messages.any?
        @context.content_tag :td, html_join(messages), class: 'error Cart-ItemsTable_item-errors'
      else
        @context.content_tag :td
      end
    end

    def html_join messages
      messages.map(& @context.method(:h)).join('<br>').html_safe
    end

    def remove_confirm_message
      I18n.t REMOVE_MESSAGE_KEY, items: @context.pluralize(quantity, name)
    end

  end
end