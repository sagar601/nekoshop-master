class ItemQuantityValidator

  def validate item
    errors = []
    errors << quantity_must_be_positive_error if item.quantity < 0
    errors << not_enough_stock_error if item.virtual_cat.nil? || item.quantity > item.virtual_cat.stock

    item.errors[:quantity] = errors

    errors.empty?
  end

  private

  def quantity_must_be_positive_error
    I18n.t('validators.item_quantity.must_be_positive', default: 'must be greater than 0')
  end

  def not_enough_stock_error
    I18n.t('validators.item_quantity.too_high_for_stock', default: 'is too high for the stock available')
  end

end