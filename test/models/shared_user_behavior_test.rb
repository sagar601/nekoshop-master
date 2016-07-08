module SharedUserBehaviorTest
  extend Minitest::Spec::DSL

  let(:new_subject) { subject.class.new }

  it 'has a name' do
    subject.name = 'Jingles'
    subject.name.must_equal 'Jingles'
  end

  it 'has a default name' do
    new_subject.name.to_s.empty?.must_equal false
  end

  it 'has a customer' do
    customer = Customer.new

    subject.customer = customer
    subject.customer.must_equal customer
  end

  specify 'new users start with a default customer' do
    new_subject.customer.wont_be_nil
  end
end