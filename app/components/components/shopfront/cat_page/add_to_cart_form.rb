class Components::Shopfront::CatPage::AddToCartForm
  using Augmented::Objects
  using Augmented::Hashes

  def initialize cat:
    @cat = cat
  end

  attr_reader :cat

  def new_item
    CartItem.new
  end

  def recombobulator_props
    cat = @cat.pick(
      :price,
      {options: [
        :id,
        :name,
        variations: [
          :id,
          :name
        ]
      ]},
      virtual_cats: [
        :id,
        :vcid,
        :stock,
        :price
      ]
    ).transform! price: :format, virtual_cats: { price: :format, vcid: :to_a }

    { cat: cat }
  end

end