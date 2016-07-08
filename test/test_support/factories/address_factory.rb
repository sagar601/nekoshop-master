class AddressFactory

  def self.build
    Address.new(
      name: Faker::Name.name,
      phone: Faker::PhoneNumber.cell_phone,
      line1: Faker::Address.street_address,
      line2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      postal_code: Faker::Address.postcode,
      country: Faker::Address.country_code,
    )
  end

end