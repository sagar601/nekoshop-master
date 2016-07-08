require 'test_helper'

require_relative '../admin_action_test'

describe Admin::Stocks::Edit do

  let(:virtual_cats) { Array.new(3) { VirtualCat.new stock: 10 } }
  let(:cat) { Cat.new virtual_cats: virtual_cats }
  let(:repo) { Monkey.new CatRepository, find: cat }

  def build_action user:
    Admin::Stocks::Edit.new user: user, cat_id: nil, cat_repo: repo
  end

  include AdminActionTest

  it 'returns a form to the edit the cat' do
    result = build_action(user: User::Admin.new).call
    result.form.virtual_cats.count.must_equal virtual_cats.count
  end

  it 'also returns the cat fetched from the repo' do
    result = build_action(user: User::Admin.new).call
    result.cat.must_equal cat
  end

end