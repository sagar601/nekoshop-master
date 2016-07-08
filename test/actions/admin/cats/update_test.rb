require 'test_helper'

require_relative '../admin_action_test'
require_relative '../../../test_support/factories/cat_factory'

describe Admin::Cats::Update do

  before do
    @cat = CatFactory.create!
  end

  def build_action user:, cat_params: Hash.new
    Admin::Cats::Update.new user: user, cat_id: @cat.id, params: { 'cat' => cat_params }
  end

  include AdminActionTest

  it 'gets a cat from the repository' do
    result = build_action(user: User::Admin.new).call

    result.cat.must_equal @cat
  end

  it 'wraps a form around the cat' do
    result = build_action(user: User::Admin.new).call

    result.form.model.must_equal @cat
  end

  it 'creates a new cat if given a `:new` id' do
    cat_params = {
      'name' => 'new dummy name',
      'species' => 'species',
      'summary' => 'summary',
      'description' => 'description',
    }

    result = Admin::Cats::Update.new(user: User::Admin.new, cat_id: :new, params: { 'cat' => cat_params }).call

    result.updated?.must_equal true
    Cat.find_by_name('new dummy name').wont_be_nil
  end

  it 'updates attributes of the cat' do
    cat_params = { 'name' => 'dummy name' }

    result = build_action(user: User::Admin.new, cat_params: cat_params).call

    result.updated?.must_equal true
    result.cat.name.must_equal 'dummy name'
  end

  it 'does not update cat if validations fail' do
    too_big_name = 'too_big_name' * 20
    cat_params = { 'name' => too_big_name }

    result = build_action(user: User::Admin.new, cat_params: cat_params).call

    result.updated?.must_equal false
    result.cat.name.wont_equal too_big_name
  end

end