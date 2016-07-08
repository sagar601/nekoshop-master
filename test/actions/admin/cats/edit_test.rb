require 'test_helper'

require_relative '../admin_action_test'

describe Admin::Cats::Edit do

  let(:cat) { Cat.new }
  let(:repo) { Monkey.new CatRepository, find: cat }

  def build_action user:
    Admin::Cats::Edit.new user: user, cat_id: cat.id, cat_repo: repo
  end

  include AdminActionTest

  it 'gets a cat from the repository' do
    result = build_action(user: User::Admin.new).call

    result.cat.must_equal cat
  end

  it 'instantiates a new cat if provided with a `:new` id' do
    result = Admin::Cats::Edit.new(user: User::Admin.new, cat_id: :new).call

    result.cat.new_record?.must_equal true
  end

  it 'wraps a form around the cat' do
    result = build_action(user: User::Admin.new).call

    result.form.model.must_equal cat
  end

end