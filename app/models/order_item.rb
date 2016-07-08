class OrderItem < ActiveRecord::Base
  belongs_to :order, inverse_of: :items

  monetize :base_price_cents, as: 'base_price'
  monetize :options_cost_cents, as: 'options_cost'

  def summary
    "#{quantity} x #{name}"
  end
end