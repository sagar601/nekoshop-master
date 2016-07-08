require 'test_helper'

describe ::Components::Site::MenuBar::UserMenu do

  it 'has a user' do
    user = Object.new
    bar = ::Components::Site::MenuBar::UserMenu.new context: VoidObject.new, user: user

    bar.user.must_equal user
  end

  it 'has links to admin page, orders page and logout for admin users' do
    bar = ::Components::Site::MenuBar::UserMenu.new context: VoidObject.new, user: User::Admin.new

    all_classes = bar.links.map{ |link| link.options[:class] }.join
    all_classes.must_include 'admin-link'
    all_classes.must_include 'orders-link'
    all_classes.must_include 'sign-out-link'
  end

  it 'has links to orders page and logout for regular users' do
    bar = ::Components::Site::MenuBar::UserMenu.new context: VoidObject.new, user: User.new

    all_classes = bar.links.map{ |link| link.options[:class] }.join
    all_classes.wont_include 'admin-link'
    all_classes.must_include 'orders-link'
    all_classes.must_include 'sign-out-link'
  end

end