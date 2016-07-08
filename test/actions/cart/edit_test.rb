require 'test_helper'

require_relative 'cart_action_behavior'

describe Cart::Edit do
  include CartActionBehavior

  def build_action *args
    Cart::Edit.new *args
  end

end