require 'test_helper'

describe 'Shopfront Cat Page', :capybara do

  before do
    @spotty = Cat.create(
      name: 'Spotty',
      species: 'spottimus maximus',
      price: Money.new(999),
      summary: 'Lorem ipsum',
      description: 'Lorem ipsum dolor sit amet.'
    )

    @spotty.photos << CatPhoto.new(image: TestHelpers.dummy_image_file, headshot: true)
    @spotty.photos << CatPhoto.new(image: TestHelpers.dummy_image_file)

    @spotty.virtual_cats.first.update_attribute :stock, 10
  end

  it "shows the cat's details" do
    visit cat_path(@spotty)

    within '.Shopfront-CatPage-CatSheet' do
      page.must_have_content @spotty.name
      page.must_have_content @spotty.species
      page.must_have_content @spotty.summary
      page.must_have_content @spotty.description
      # page.must_have_content '9.99'
      # page.must_have_content '€'
    end
  end

  it 'lets you add the cat to your shopping cart if available' do
    visit cat_path(@spotty)

    page.find('#add_to_cart_button').click

    current_path.must_equal cart_path
    assert_positive_flash_message
  end

  it 'prevents you from adding an unavailable cat to the cart' do
    @spotty.virtual_cats.first.update_attribute :stock, 0

    visit cat_path(@spotty)

    page.must_have_selector '#add_to_cart_button[disabled]'
  end

  it 'prevents you from adding an unavailable cat to the cart even when stock runs out before you reload the page' do
    visit cat_path(@spotty)

    @spotty.virtual_cats.first.update_attribute :stock, 0

    page.find('#add_to_cart_button').click

    current_path.must_equal cat_path(@spotty)
    assert_negative_flash_message
  end

end