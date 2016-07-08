class Components::Checkout::AccountPrompts

  def initialize return_url:
    @return_url = return_url
  end

  attr_reader :return_url

end