class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :customer, dependent: :destroy, inverse_of: :user

  def name
    super || self.class.model_name.human
  end

  def guest?
    false
  end

  def admin?
    false
  end

  def registered?
    true
  end

  def customer
    super || build_customer
  end

end
