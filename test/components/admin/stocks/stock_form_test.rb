require 'test_helper'

describe Components::Admin::Stocks::StockForm do

  let(:form_object) { Object.new }

  let(:component) { Components::Admin::Stocks::StockForm.new form: form_object, url: 'dummy_url', return_path: 'dummy_return_path' }

  it 'has a form object' do
    component.form.must_equal form_object
  end

  it 'has an action url' do
    component.url.must_equal 'dummy_url'
  end

  it 'has form method' do
    component.method.must_equal :post
  end

  it 'has a return path' do
    component.return_path.must_equal 'dummy_return_path'
  end

  it 'can wrap a virtual cat in a util row object' do
    vc = Monkey.imitate VirtualCat.new stock: 11
    component.wrap(vc).stock.must_equal vc.stock
  end

  describe 'util row object' do

    it 'has a text representation of the variations of the virtual cat' do
      vc = Monkey.imitate VirtualCat.new, singular?: true

      component.wrap(vc).combination.to_s.wont_be_empty

      vc = Monkey.imitate VirtualCat.new, singular?: false, variations: [ OpenStruct.new(name: 'aaa'), OpenStruct.new(name: 'bbb') ]

      component.wrap(vc).combination.must_include 'aaa'
      component.wrap(vc).combination.must_include 'bbb'
    end

    it 'has different css classes and warnings if it has low or no stock' do
      vc = Monkey.imitate VirtualCat.new stock: 20
      wrapped = component.wrap vc

      wrapped.row_classes.to_s.must_be_empty
      wrapped.warning.to_s.must_be_empty

      vc = Monkey.imitate VirtualCat.new stock: 5
      wrapped = component.wrap vc

      wrapped.row_classes.to_s.wont_be_empty
      wrapped.warning.to_s.wont_be_empty

      vc = Monkey.imitate VirtualCat.new stock: 0
      wrapped = component.wrap vc

      wrapped.row_classes.to_s.wont_be_empty
      wrapped.warning.to_s.wont_be_empty
    end

  end

end