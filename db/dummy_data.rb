module DummyData
  CAT_API_URL = 'http://thecatapi.com/api/images/get?format=src&size=med'

  def self.load
    create_spotty
    create_stripy
    create_listy
    create_users
  end

  def self.create_spotty
    spotty = Cat.create(
      name: 'Spotty',
      species: 'spottimus maximus',
      price: Money.new(999),
      summary: Faker::Lorem.sentence,
      description: Faker::Lorem.paragraph
    )

    spotty.photos << CatPhoto.new(headshot: true, image_url: CAT_API_URL)
    spotty.photos << CatPhoto.new(image_url: CAT_API_URL)
    spotty.photos << CatPhoto.new(image_url: CAT_API_URL)

    spotty.virtual_cats = [VirtualCat.new(stock: 10)]
  end

  def self.create_stripy
    stripy = Cat.create(
      name: 'Stripy',
      species: 'stripeouis fancis',
      price: Money.new(1299),
      summary: Faker::Lorem.sentence
    )

    stripy.photos << CatPhoto.new(headshot: true, image_url: CAT_API_URL)

    stripy.virtual_cats = [VirtualCat.new(stock: 10)]
  end

  def self.create_listy
    # Listy is a very humble cat
    listy = Cat.create name: 'Listy', species: 'stripeouis fancis', price: Money.new(1149)

    listy.virtual_cats = [VirtualCat.new]
  end

  def self.create_users
    User.create name: 'Jingles', email: 'jingles@example.com', password: 'password'
    User::Admin.create name: 'Anna', email: 'anna@example.com', password: 'password'
  end
end