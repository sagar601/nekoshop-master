class CreditCard
  include ::Virtus.model

  attribute :token
  attribute :brand
  attribute :last4
  attribute :exp_month, Integer
  attribute :exp_year, Integer
end