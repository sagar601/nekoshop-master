class Components::Address

  def initialize address:, title: '', wrapper_classes: ''
    @address = address
    @title = title
    @wrapper_classes = wrapper_classes
  end

  attr_reader :wrapper_classes

  def address
    @decorated_address ||= AddressDecorator.new @address
  end

  def title
    "<h3>#{@title}</h3>" unless @title.to_s.empty?
  end


  class AddressDecorator < SimpleDelegator

    def country
      ISO3166::Country.new(super).name
    end

  end

end