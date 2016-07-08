module IsAddressable
  extend ActiveSupport::Concern

  def address
    @address ||= Address.new super
  end

  def address= attributes
    @address = Address.new attributes
    super @address.attributes
  end
end