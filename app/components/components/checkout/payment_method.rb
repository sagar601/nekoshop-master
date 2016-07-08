class Components::Checkout::PaymentMethod

  def initialize method:, wrapped: true, title: ''
    @method = method
    @wrapped = wrapped
    @title = title
  end

  def wrapper_classes
    'ui segment' if @wrapped
  end

  def title
    "<h3>#{@title}</h3>" unless @title.to_s.empty?
  end

  def card_brand
    card.brand
  end

  def card_number
    "**** **** **** #{card.last4}"
  end

  def card_expiration_date
    I18n.l Date.new(card.exp_year, card.exp_month), format: '%B %Y'
  end

  private

  def card
    @card ||= @method.card
  end

end