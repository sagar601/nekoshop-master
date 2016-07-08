require 'test_helper'

describe 'Shopfront', :capybara do

  before do
    @spotty = Cat.create name: 'Spotty', species: 'spottimus maximus', price: Money.new(999)
    @stripy = Cat.create name: 'Stripy', species: 'stripeouis fancis', price: Money.new(1299)
  end

  it "displays cats" do
    visit root_path

    within '.Shopfront-CatGrid' do
      page.must_have_selector '.Shopfront-CatCard', count: 2

      page.must_have_content 'Spotty'
      page.must_have_content '9.99'

      page.must_have_content 'Stripy'
      page.must_have_content '12.99'

      within first('.Shopfront-CatCard') do
        page.must_have_content '€'
      end
    end
  end

  it "links to each cat's detail page" do
    visit root_path

    within first('.Shopfront-CatGrid .Shopfront-CatCard') do
      page.find('.Shopfront-CatCard_details-button').click

      current_path.must_equal cat_path(@spotty)
    end

    visit root_path

    within first('.Shopfront-CatGrid .Shopfront-CatCard') do
      page.find('.Shopfront-CatCard_cart-button').click

      current_path.must_equal cat_path(@spotty)
    end
  end

  it "shows a friendly message when there are no cats" do
    visit root_path
    page.wont_have_selector('.Shopfront-CatGrid_no-cats-message')

    Cat.all.each &:destroy!

    visit root_path
    page.must_have_selector('.Shopfront-CatGrid_no-cats-message')
  end

  describe "sidebar species filter" do

    it 'has a button for each species available' do
      visit root_path

      within '.Shopfront-SpeciesFilter' do
        page.must_have_content @spotty.species
        page.must_have_content @stripy.species
      end
    end

    it 'filters cats by species' do
      visit root_path

      page.find('.Shopfront-SpeciesFilter .item', text: @spotty.species).click

      within '.Shopfront-CatGrid' do
        page.must_have_selector '.Shopfront-CatCard', count: 1

        within first('.Shopfront-CatCard') do
          page.must_have_content @spotty.name
        end
      end
    end

    specify "its first button resets the filter" do
      visit root_path

      page.find('.Shopfront-SpeciesFilter .item', text: @spotty.species).click
      page.all('.Shopfront-SpeciesFilter .item').first.click

      within '.Shopfront-CatGrid' do
        page.must_have_selector '.Shopfront-CatCard', count: 2
      end
    end

  end

end