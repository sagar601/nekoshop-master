class CreditCardFactory

  def self.build
    make_last4 = -> { rand(9999).to_s.rjust 4, '0' }

    CreditCard.new(
      brand: 'VISA',
      last4: make_last4.call,
      exp_month: (1..12).to_a.sample,
      exp_year: (2016..2026).to_a.sample
    )
  end

end