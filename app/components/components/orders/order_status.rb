class Components::Orders::OrderStatus
  include ComponentTranslationHelpers

  def initialize order:
    @order = order
  end

  def color
    case
    when @order.paid? then 'green'
    when @order.cancelled? then 'red'
    end
  end

  def status
    case
    when @order.paid? then t '.paid'
    when @order.cancelled? then t '.cancelled'
    else t '.pending'
    end
  end

  # Note: there is potential for extracting a status type into its own class
  # but for now this will do. Re-evaluate when we implement the orders processing
  # interface and orders have a few more states and behavior elsewhere.

end