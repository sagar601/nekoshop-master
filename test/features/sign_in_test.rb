require 'test_helper'

describe 'User Sign In', :capybara do

  before do
    @jingles = User.create name: 'Jingles', email: 'jingles@example.com', password: 'password'
    @anna = User::Admin.create name: 'Anna', email: 'anna@example.com', password: 'password'
  end

  it 'lets users in' do
    visit new_user_session_path

    page.wont_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'

    fill_in 'Email', with: @jingles.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    current_path.must_equal root_path

    page.must_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'
  end

  it 'lets admins in' do
    visit new_user_session_path

    page.wont_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'

    fill_in 'Email', with: @anna.email
    fill_in 'Password', with: 'password'
    click_button 'Log in'

    current_path.must_equal root_path

    page.must_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'
  end

  it 'requires email and password' do
    visit new_user_session_path

    click_button 'Log in'
    current_path.must_equal '/users/sign_in'

    fill_in 'Email', with: @jingles.email

    click_button 'Log in'
    current_path.must_equal '/users/sign_in'

    fill_in 'Email', with: ''
    fill_in 'Password', with: @jingles.email

    click_button 'Log in'
    current_path.must_equal '/users/sign_in'
  end

end