class Cart < ActiveRecord::Base
  belongs_to :customer, inverse_of: :cart
  has_many :items, dependent: :destroy, class_name: 'CartItem', inverse_of: :cart

  before_save { customer.save! if customer.new_record? }

  validates :customer, presence: true
  validates :items, cap: 100

  def total
    items.map(&:subtotal).reduce(Money.new(0), :+)
  end

  def count
    items.map(&:quantity).reduce(0, :+)
  end

  def is_empty?
    count.zero?
  end

  def in_stock?
    items.all? &:in_stock?
  end

  def summary
    items.map(&:summary).join("\n")
  end

  # def merge! thing_with_items
  #   my_items = self.items.index_by &:virtual_cat_id
  #   other_items = thing_with_items.items.index_by &:virtual_cat_id

  #   new_items = my_items.merge(other_items) { |key, my_item, other_item| my_item.quantity += other_item.quantity; my_item }

  #   self.items = new_items.values
  #   save!
  # end

end