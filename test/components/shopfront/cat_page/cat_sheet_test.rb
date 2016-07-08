require 'test_helper'

describe ::Components::Shopfront::CatPage::CatSheet do

  let(:cat) { Cat.new name: 'Spotty', description: 'lorem ipsum' }
  let(:sheet) { ::Components::Shopfront::CatPage::CatSheet.new cat: cat }

  it 'has a cat' do
    sheet.cat.must_equal cat
  end

  it "has a the cat's description or a placeholder one if not present" do
    sheet.cat_description.must_equal cat.description

    cat = Cat.new name: 'Non Descript'
    sheet = ::Components::Shopfront::CatPage::CatSheet.new cat: cat

    sheet.cat_description.wont_be_empty
  end

end