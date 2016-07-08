require 'test_helper'

describe Components::Admin::SidebarNav do

  let(:context) { VoidObject.new }

  it 'has a nav item to see the admin dashboard' do
    items = Components::Admin::SidebarNav.new(context: context).items
    items.first.id.must_equal :dashboard
  end

  it 'has a nav item to see the list of cats' do
    items = Components::Admin::SidebarNav.new(context: context).items
    items.second.id.must_equal :cats
  end

  it 'has a nav item to see the stocks' do
    items = Components::Admin::SidebarNav.new(context: context).items
    items.third.id.must_equal :stocks
  end

  it 'can highlight an item' do
    items = Components::Admin::SidebarNav.new(context: context).items
    items.map(&:classes).wont_include 'active'

    items = Components::Admin::SidebarNav.new(context: context, active: :dashboard).items
    items.map(&:classes).must_include 'active'
  end

end