require 'test_helper'

describe Cats::Show do

  it 'returns the cat from the repo' do
    cat = Object.new
    cat_repo = Monkey.new CatRepository, find: cat

    result = Cats::Show.new(id: 123, cat_repo: cat_repo).call

    result.cat.must_equal cat
  end

end