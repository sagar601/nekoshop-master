require 'test_helper'

describe Components::Admin::Cats::CatTable do

  let(:cats) { [ Cat.new, Cat.new ] }
  let(:table) { Components::Admin::Cats::CatTable.new cats: cats }

  it 'has cats' do
    table.cats.must_equal cats
  end

end