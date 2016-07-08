require 'test_helper'

require_relative '../admin_action_test'

describe Admin::Cats::Index do

  let(:cats) { Array.new.tap do |array|
    def array.includes *; self; end
    def array.page *; self; end
  end }

  let(:repo) { Monkey.new CatRepository, all: cats }

  def build_action user:
    Admin::Cats::Index.new user: user, params: {}, cat_repo: repo
  end

  include AdminActionTest

  it 'gets cats from the repository' do
    result = build_action(user: User::Admin.new).call

    result.cats.must_equal cats
  end

end