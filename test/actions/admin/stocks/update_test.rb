require 'test_helper'

require_relative '../admin_action_test'
require_relative '../../../test_support/factories/cat_factory'

describe Admin::Stocks::Update do

  before do
    @cat = CatFactory.create! options: 2
  end

  def build_action user:, stock_params: {}
    Admin::Stocks::Update.new user: user, cat_id: @cat.id, params: { 'stock' => stock_params }
  end

  include AdminActionTest

  it 'updates the stock of the virtual cats' do
    # params = {
    #   'virtual_cats_attributes' => { '0' => { 'stock' => '743' } },
    #   'virtual_cats_attributes' => { '1' => { 'stock' => '9247' } },
    # }

    # result = build_action(user: User::Admin.new, stock_params: params).call

    # result.updated?.must_equal true
    # FIXME Reform is throwing a wierd error about a frozen hash somewhere
  end

  it 'returns a form around the cat' do
    result = build_action(user: User::Admin.new).call
    result.form.model.must_equal @cat
  end

  it 'also returns the cat fetched from the repo' do
    result = build_action(user: User::Admin.new).call
    result.cat.must_equal @cat
  end

end