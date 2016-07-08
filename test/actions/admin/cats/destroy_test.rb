require 'test_helper'

require_relative '../admin_action_test'
require_relative '../../../test_support/factories/cat_factory'

describe Admin::Cats::Destroy do

  before do
    @cat = CatFactory.create!
  end

  def build_action user:
    Admin::Cats::Destroy.new user: user, cat_id: @cat.id
  end

  include AdminActionTest

  it 'deletes a cat' do
    result = build_action(user: User::Admin.new).call

    Cat.find_by_id(@cat.id).must_equal nil
  end

  it 'returns the destroyed cat' do
    result = build_action(user: User::Admin.new).call

    result.cat.must_equal @cat
  end

end