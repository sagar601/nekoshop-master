class Checkout < ActiveRecord::Base
  include IsAddressable

  belongs_to :cart
  belongs_to :customer, inverse_of: :checkout
  has_one :payment_method, inverse_of: :checkout

  after_destroy :destroy_payment_method_if_its_mine!

  validates :cart, presence: true
  validates :customer, presence: true

  def cart
    super
  end

  def shipping_cost_determinable?
    address.country.present?
  end

  def shipping_cost
    shipping_cost_determinable? ? Money.new(2000) : Money.new(0) # TODO implement shipping costs interface
  end

  def total
    cart.total + shipping_cost
  end

  def free?
    total.zero?
  end

  def address
    super.blank? && !customer.nil? ? customer.address : super
  end

  def guest?
    customer.user.guest? # WARN reaching too far up
  end

  def payment_method
    super.nil? && !customer.nil? ? customer.payment_method : super
  end

  def has_payment_method?
    !payment_method.nil?
  end

  def summary
    cart.summary
  end

  def expire!
    self.destroy!
  end

  private

  def destroy_payment_method_if_its_mine!
    payment_method && payment_method.customer.nil? and payment_method.destroy!
  end

end
