class Address
  include ::Virtus.value_object

  values do
    attribute :name
    attribute :line1
    attribute :line2
    attribute :postal_code
    attribute :city
    attribute :country
    attribute :phone
  end

  def blank?
    attributes.values.all? &:blank?
  end

end