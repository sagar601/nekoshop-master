require_relative '../test_support/factories/credit_card_factory'

module PaymentMethodBehaviorTest
  extend Minitest::Spec::DSL

  let(:credit_card) { CreditCardFactory.build }

  it "has a credit card" do
    subject.card = credit_card

    subject.card.brand.must_equal credit_card.brand
    subject.card.last4.must_equal credit_card.last4
    subject.card.exp_month.must_equal credit_card.exp_month
    subject.card.exp_year.must_equal credit_card.exp_year
  end

end