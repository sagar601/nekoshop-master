class CartItem < ActiveRecord::Base
  extend Forwardable

  belongs_to :cart, inverse_of: :items
  belongs_to :virtual_cat

  before_save { cart.save! if cart.new_record? }

  def_delegators :virtual_cat, :name, :base_price, :options_cost

  validates :cart, presence: true
  validates :virtual_cat, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def variations
    virtual_cat.variations.map &:name
  end

  def unit_price
    virtual_cat.price
  end

  def subtotal
    unit_price * quantity
  end

  def summary
    "#{quantity} x #{name}"
  end

  def in_stock?
    !virtual_cat.nil? && virtual_cat.stock >= quantity
  end
end