require 'test_helper'

require_relative 'cart_action_behavior'

describe Cart::Show do
  include CartActionBehavior

  def build_action *args
    Cart::Show.new *args
  end

end