require 'test_helper'

describe 'User Registration', :capybara do

  it 'allows users to create an account' do
    visit new_user_registration_path

    page.wont_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'

    fill_in 'Name', with: 'Jingles'
    fill_in 'Email', with: 'jingles@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    click_button 'Sign up'

    current_path.must_equal root_path

    page.must_have_selector '.Site-MenuBar .Site-MenuBar-UserMenu'

    User.last.type.must_equal 'User'
    User.last.email.must_equal 'jingles@example.com'
  end

  it 'rejects sign ups without email or password' do
    visit new_user_registration_path

    assert_registration_fails

    fill_in 'Email', with: 'jingles@example.com'
    assert_registration_fails

    fill_in 'Email', with: ''
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'
    assert_registration_fails
  end

  it 'prevents user from using an existing email address' do
    @jingles = User.create name: 'Jingles', email: 'jingles@example.com', password: 'password'

    visit new_user_registration_path

    fill_in 'Name', with: 'Jingles2'
    fill_in 'Email', with: 'jingles@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    assert_registration_fails
  end

  def assert_registration_fails
    click_button 'Sign up'
    current_path.must_equal '/users'
    page.must_have_selector '.ui.negative.message'
  end

end