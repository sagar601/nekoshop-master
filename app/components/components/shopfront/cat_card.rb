class Components::Shopfront::CatCard

  def initialize context:, cat:
    @context = context
    @cat = cat
  end

  attr_reader :cat

  def cat_path
    @context.cat_path cat
  end

  def price
    cat.price.format
  end

end