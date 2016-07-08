module AddressableTest
  extend Minitest::Spec::DSL

  it 'has an address' do
    subject.must_respond_to :address
    subject.must_respond_to :address=
  end

  it 'returns a blank address by default' do
    default_address = subject.class.new.address

    default_address.must_be_kind_of Address
    default_address.blank?.must_equal true
  end

  it 'is settable with an attributes hash' do
    subject.address = { name: 'Marianne', city: 'Eleven' }

    subject.address.name.must_equal 'Marianne'
    subject.address.city.must_equal 'Eleven'
  end

  it 'is settable with an address object' do
    address = Address.new(name: 'Marianne', city: 'Eleven')
    subject.address = address

    subject.address.name.must_equal 'Marianne'
    subject.address.city.must_equal 'Eleven'
  end

end
