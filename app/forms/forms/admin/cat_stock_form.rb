class Forms::Admin::CatStockForm < Reform::Form

  collection :virtual_cats do
    property :stock, validates: { numericality: { greater_than_or_equal_to: 0 } }
  end

end