class CatFactory

  def self.create! options: 0
    cat = Cat.create(
      name: Faker::Name.name,
      species: Faker::Lorem.words(2).join(' '),
      price: positive_money,
      summary: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph
    )

    options.times{ cat.options << build_option }

    cat.sync_virtual_cats!
    cat.reload
  end

  def self.cleanup!
    Cat.all.each &:destroy!
  end

  private

  def self.build_option
    Option.new(
      name: Faker::Lorem.word,
      description: Faker::Lorem.sentence,
      variations: build_variations,
    )
  end

  def self.build_variations how_many = 3
    Array.new(how_many) { build_variation }
  end

  def self.build_variation
    Variation.new(
      name: Faker::Lorem.word,
      cost: positive_money,
    )
  end

  def self.positive_money
    Money.new(rand(10000) + 1)
  end

end