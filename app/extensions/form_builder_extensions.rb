module FormBuilderExtensions

  def self.included base
    ActionView::Helpers::FormBuilder.include ExtraFormHelpers
  end

  module ExtraFormHelpers

    def money method, options = {}
      defaults = { min: 0, max: 10000, step: 0.01, placeholder: '0.00', currency: Money.default_currency.symbol }
      options = defaults.merge options

      @template.content_tag :div, class: 'ui right labeled input' do
        self.number_field(method, options) +
        @template.content_tag(:div, options[:currency], class: 'ui basic label')
      end
    end

  end

end