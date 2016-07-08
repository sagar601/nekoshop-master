require 'test_helper'

require_relative '../../../test_support/factories/cat_factory'
require_relative '../../../test_support/factories/user_factory'

describe 'Update cat page', :capybara do

  before do
    @cat = CatFactory.create!
    @admin = UserFactory.create_admin!
  end

  it 'is accessible to admins only' do
    assert_access_restricted edit_admin_cat_path(@cat), User::Admin
  end

  it 'allows admin to update cat' do
    login_as @admin, scope: :user
    visit edit_admin_cat_path @cat

    fill_in 'cat[name]', with: 'name'
    fill_in 'Species', with: 'species'
    fill_in 'Summary', with: 'summary'
    fill_in 'cat[description]', with: 'description'

    click_on 'Update Cat'

    current_path.must_equal admin_cats_path
    assert_positive_flash_message

    @cat.reload
    @cat.name.must_equal 'name'
    @cat.species.must_equal 'species'
    @cat.summary.must_equal 'summary'
    @cat.description.must_equal 'description'
  end

  it 'shows validations errors if any' do
    login_as @admin, scope: :user
    visit edit_admin_cat_path @cat

    fill_in 'Species', with: ('too_big' * 20)

    click_on 'Update Cat'

    page.must_have_selector '.FormValidationErrors'
  end

  it 'allows admin to cancel update and go back to the cat list' do
    login_as @admin, scope: :user
    visit edit_admin_cat_path @cat

    click_on 'Cancel'

    current_path.must_equal admin_cats_path
  end

  it 'allows admin to delete the cat' do
    login_as @admin, scope: :user
    visit edit_admin_cat_path @cat

    page.find('#delete_cat_button').click

    current_path.must_equal admin_cats_path
    assert_positive_flash_message

    Cat.find_by_id(@cat.id).must_equal nil
  end

  it 'allows admin to edit the options of the cat' do
    option = Option.new name: 'cat option', description: 'lorem ipsum'
    variation = Variation.new name: 'option variation', cost: Money.new(10)

    option.variations << variation
    @cat.options << option

    login_as @admin, scope: :user
    visit edit_admin_cat_path @cat

    fill_in 'cat[options_attributes][0][name]', with: 'new option name'
    fill_in 'cat[options_attributes][0][description]', with: 'new option description'

    fill_in 'cat[options_attributes][0][variations_attributes][0][name]', with: 'new variation name'
    fill_in 'cat[options_attributes][0][variations_attributes][0][cost]', with: '9'

    click_on 'Update Cat'

    option.reload.name.must_equal 'new option name'
    option.description.must_equal 'new option description'

    variation.reload.name.must_equal 'new variation name'
    variation.cost.must_equal Money.new(900)
  end

  it 'displays the admin sidebar nav' do
    login_as @admin, scope: :user
    visit edit_admin_cat_path @cat

    page.must_have_selector '.Admin-SidebarNav'
  end

end