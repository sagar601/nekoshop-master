class Components::Shopfront::CatGrid

  def initialize cats:
    @cats = cats
  end

  attr_reader :cats

  def paginate?
    @cats.total_count > @cats.size
  end
end