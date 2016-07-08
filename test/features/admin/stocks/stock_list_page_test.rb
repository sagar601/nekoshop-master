require 'test_helper'

require_relative '../../../test_support/factories/cat_factory'
require_relative '../../../test_support/factories/user_factory'

describe 'Admin stocks page', :capybara do

  before do
    @cat = CatFactory.create!
    @cat.virtual_cats.first.update_attribute :stock, 152
    @admin = UserFactory.create_admin!
  end

  it 'is accessible to admins only' do
    assert_access_restricted admin_stocks_path, User::Admin
  end

  it 'displays the list of cats and their stocks' do
    login_as @admin, scope: :user
    visit admin_stocks_path

    within('.Admin-StocksTable tbody') do
      page.must_have_content @cat.name
      page.must_have_content @cat.stock
    end
  end

  it "allows admin to go edit a cat's stock from the list" do
    login_as @admin, scope: :user
    visit admin_stocks_path

    page.find('.Admin-StocksTable tbody tr:first-child a:first-child').click

    current_path.must_equal edit_admin_stock_path @cat
  end

  it 'displays the admin sidebar nav' do
    login_as @admin, scope: :user
    visit admin_stocks_path

    page.must_have_selector '.Admin-SidebarNav'
  end

end