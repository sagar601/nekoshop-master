class Components::Checkout::AddressForm

  def initialize address:, rememberable: false
    @address = address
    @rememberable = rememberable
  end

  attr_reader :address, :rememberable

end