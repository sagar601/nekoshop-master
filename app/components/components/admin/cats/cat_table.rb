class Components::Admin::Cats::CatTable

  def initialize cats:
    @cats = cats
  end

  attr_reader :cats

end