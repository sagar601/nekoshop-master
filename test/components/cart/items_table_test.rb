require 'test_helper'

describe Components::Cart::ItemsTable do

  def make_item name, quantity, errors = []
    item = CartItem.new quantity: quantity

    Monkey.imitate item, name:       name,
                         unit_price: Money.new(99),
                         variations: Faker::Lorem.words(3),
                         errors:     OpenStruct.new(full_messages: errors)
  end

  def make_context
    context = NullObject.new
    context.define_singleton_method(:pluralize) { |*args| args.to_s }
    context.define_singleton_method(:content_tag) { |*args| "<td>#{args.second}</td>" }
    context.define_singleton_method(:h) { |arg| arg }
    context
  end

  let(:items)   { [ make_item('Spotty', 1), make_item('Stripy', 2), make_item('Randy', 5, ['dummy_error']) ] }
  let(:table)   { Components::Cart::ItemsTable.new context: make_context, cart: Cart.new(items: items) }

  it 'has one decorated item for each cart item' do
    table.respond_to? :items
    table.items.count.must_equal items.count
  end

  it 'renders a different partial when in edit mode' do
    editable_table = Components::Cart::ItemsTable.new context: nil, cart: nil, edit: true

    editable_table.to_partial_path.wont_equal table.to_partial_path
  end

  describe 'each decorated item' do

    it 'has the item name' do
      table.items.map(&:name).must_contain items.map(&:name)
    end

    it 'has the item quantity' do
      table.items.map(&:quantity).must_contain items.map(&:quantity)
    end

    it 'has the item unit price' do
      table.items.map(&:unit_price).must_contain items.map(&:unit_price).map(&:format)
    end

    it "has an options string which is an aggregation of the item's variations" do
      table.items.each do |item|
        item.variations.all?{ |variation| item.options.include? variation }.must_equal true
      end
    end

    it 'has a unique removal confirmation message' do
      table.items.map(&:remove_confirm_message).uniq.count.must_equal items.count
    end

    it "has an html table cell with the item's errors in it" do
      good_item = table.items.first
      bad_item = table.items.third

      good_item.errors_cell.must_equal '<td></td>'

      bad_item.errors_cell.start_with?('<td').must_equal true
      bad_item.errors_cell.include?('dummy_error').must_equal true
    end
  end
end