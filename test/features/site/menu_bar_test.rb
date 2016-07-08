require 'test_helper'

describe 'Site Menu Bar', :capybara do

  before do
    @jingles = User.create name: 'Jingles', email: 'jingles@example.com', password: 'password'
    @anna = User::Admin.create name: 'Anna', email: 'anna@example.com', password: 'password'
  end

  after do
    Warden.test_reset!
  end

  it "has a link to the homepage" do
    visit root_path

    page.first('.Site-MenuBar a.item').click

    current_path.must_equal root_path
  end

  it 'has sign in and sign up links for guest users' do
    visit root_path

    page.find('.Site-MenuBar_sign-in-link').click
    current_path.must_equal new_user_session_path

    page.find('.Site-MenuBar_sign-up-link').click
    current_path.must_equal new_user_registration_path
  end

  it 'has a user menu for logged in users' do
    login_as @jingles, scope: :user
    visit root_path

    page.must_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'
  end

  it 'has a user menu for logged in admins' do
    login_as @anna, scope: :user
    visit root_path

    page.must_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'
  end

  describe 'user menu' do

    it 'has a link to the admin backoffice if user is an admin' do
      login_as @anna, scope: :user
      visit root_path

      page.find('.Site-MenuBar .Site-MenuBar-UserMenu_admin-link').click

      current_path.must_equal admin_dashboard_path
    end

    it 'has a link to orders page' do
      login_as @anna, scope: :user
      visit root_path

      page.find('.Site-MenuBar .Site-MenuBar-UserMenu_orders-link').click

      current_path.must_equal orders_path
    end

    it 'has a logout link' do
      login_as @jingles, scope: :user
      visit root_path

      page.find('.Site-MenuBar .Site-MenuBar-UserMenu_sign-out-link').click

      current_path.must_equal root_path
      page.wont_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'
    end
  end

  it 'has a shopping cart summary button' do
    visit root_path

    page.must_have_selector '.Site-MenuBar .Site-MenuBar-CartCounter'
  end

  describe 'cart counter item' do

    it 'links to the cart page' do
      visit root_path

      page.find('.Site-MenuBar .Site-MenuBar-CartCounter').click

      current_path.must_equal cart_path
    end

    it 'tells how many items are in your cart' do
      @spotty = Cat.create! name: 'Spotty', price: Money.new(99), virtual_cats: [ VirtualCat.new(stock: 10) ]
      @stripy = Cat.create! name: 'Stripy', price: Money.new(99), virtual_cats: [ VirtualCat.new(stock: 10) ]

      visit root_path

      within '.Site-MenuBar .Site-MenuBar-CartCounter' do
        page.must_have_content '0'
      end

      visit cat_path(@spotty)
      page.find('#add_to_cart_button').click

      within '.Site-MenuBar .Site-MenuBar-CartCounter' do
        page.must_have_content '1'
      end

      visit cat_path(@spotty)
      page.find('#add_to_cart_button').click

      within '.Site-MenuBar .Site-MenuBar-CartCounter' do
        page.must_have_content '2'
      end

      visit cat_path(@stripy)
      page.find('#add_to_cart_button').click

      within '.Site-MenuBar .Site-MenuBar-CartCounter' do
        page.must_have_content '3'
      end
    end
  end

end