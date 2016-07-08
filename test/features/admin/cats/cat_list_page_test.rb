require 'test_helper'

require_relative '../../../test_support/factories/cat_factory'
require_relative '../../../test_support/factories/user_factory'

describe 'Admin cat page', :capybara do

  before do
    @cat1 = CatFactory.create!
    @cat2 = CatFactory.create!
    @admin = UserFactory.create_admin!
  end

  it 'displays the list of cats' do
    login_as @admin, scope: :user
    visit admin_cats_path

    page.must_have_content @cat1.name
    page.must_have_content @cat2.name
  end

  it 'allows admin to edit a cat from the list' do
    login_as @admin, scope: :user
    visit admin_cats_path

    page.find('.CatTable tbody tr:first-child a:first-child').click

    current_path.must_equal edit_admin_cat_path @cat1
  end

  it 'allows admin to add a new cat' do
    login_as @admin, scope: :user
    visit admin_cats_path

    page.find('#add_new_cat_button').click

    current_path.must_equal new_admin_cat_path
  end

  it 'has a paginator to change page' do
    100.times{ CatFactory.create! }

    login_as @admin, scope: :user
    visit admin_cats_path

    page.all('.Pager a').last.click

    current_url.must_match /page=5/
  end

  it 'displays the admin sidebar nav' do
    login_as @admin, scope: :user
    visit admin_cats_path

    page.must_have_selector '.Admin-SidebarNav'
  end

  it 'is accessible to admins only' do
    assert_access_restricted admin_cats_path, User::Admin
  end

end