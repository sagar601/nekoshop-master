require 'test_helper'

require_relative '../../../test_support/factories/cat_factory'
require_relative '../../../test_support/factories/user_factory'

describe 'Update cat stock page', :capybara do

  before do
    @cat = CatFactory.create! options: 2
    @admin = UserFactory.create_admin!
  end

  it 'is accessible to admins only' do
    assert_access_restricted edit_admin_stock_path(@cat), User::Admin
  end

  it 'displays the list of virtual cats and their stocks' do
    login_as @admin, scope: :user
    visit edit_admin_stock_path(@cat)

    page.must_have_selector '.Admin-VirtualCatStocks tbody tr', count: @cat.virtual_cats.count
  end

  it "allows admin to go edit any virtual cat's stock" do
    login_as @admin, scope: :user
    visit edit_admin_stock_path(@cat)

    fill_in 'stock[virtual_cats_attributes][0][stock]', with: '1234'
    fill_in 'stock[virtual_cats_attributes][1][stock]', with: '9876'
    fill_in 'stock[virtual_cats_attributes][2][stock]', with: '5005'

    click_on 'Update Cat stock'

    current_path.must_equal admin_stocks_path
    assert_positive_flash_message

    @cat.reload.virtual_cats.pluck(:stock).must_contain [ 1234, 9876, 5005 ]
  end

  it 'displays the admin sidebar nav' do
    login_as @admin, scope: :user
    visit edit_admin_stock_path(@cat)

    page.must_have_selector '.Admin-SidebarNav'
  end

end