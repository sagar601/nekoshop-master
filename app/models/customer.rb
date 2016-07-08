class Customer < ActiveRecord::Base
  include IsAddressable

  belongs_to :user, inverse_of: :customer
  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy, inverse_of: :customer
  has_one :checkout, dependent: :destroy, inverse_of: :customer
  has_one :payment_method, dependent: :destroy, inverse_of: :customer

  validates :user, presence: true

  def cart
    super || build_cart
  end

  def prepared_for_money?
    !external_id.to_s.empty?
  end

  def ensure_prepared_for_money! money_service
    return if prepared_for_money?

    self.external_id = money_service.create_customer self
    save!
  end

end