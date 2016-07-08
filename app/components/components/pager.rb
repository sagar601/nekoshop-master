class Components::Pager

  def initialize collection:
    @collection = collection
  end

  attr_reader :collection

end