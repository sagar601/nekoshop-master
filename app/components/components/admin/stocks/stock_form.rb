class Components::Admin::Stocks::StockForm

  def initialize form:, url:, method: :post, return_path:
    @form = form
    @url = url
    @method = method
    @return_path = return_path
  end

  attr_reader :form, :url, :method, :return_path

  def wrap virtual_cat
    VirtualCatDecorator.new virtual_cat
  end


  class VirtualCatDecorator < SimpleDelegator
    include ComponentTranslationHelpers

    def combination
      singular? ? t('.default_combination') : variations.map(&:name).join(' | ')
    end

    def no_stock?
      stock == 0
    end

    def low_stock?
      stock < 10
    end

    def row_classes
      case
      when no_stock? then 'negative'
      when low_stock? then 'warning'
      end
    end

    def warning
      case
      when no_stock? then %Q(<i class="attention icon"></i> #{t '.out_of_stock'}).html_safe
      when low_stock? then %Q(<i class="warning icon"></i> #{t '.low_stock'}).html_safe
      end
    end

  end

end