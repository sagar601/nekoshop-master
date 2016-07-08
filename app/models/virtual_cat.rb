class VirtualCat < ActiveRecord::Base
  default_scope { order('id ASC') }

  belongs_to :cat, inverse_of: :virtual_cats

  validates :cat, presence: true
  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def variations
    cat.variations.select { |v| vcid.include? v }
  end

  def name
    cat.name
  end

  def base_price
    cat.price
  end

  def options_cost
    variations.map(&:cost).reduce(Money.new(0), &:+)
  end

  def price
    base_price + options_cost
  end

  def available?
    stock > 0
  end

  def vcid
    Vcid.new super
  end

  def vcid= vcid
    super vcid.to_a
  end

  def singular?
    vcid.singular?
  end

end