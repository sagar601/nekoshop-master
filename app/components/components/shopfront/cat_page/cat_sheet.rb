class Components::Shopfront::CatPage::CatSheet
  PLACEHOLDER_DESCRIPTION = I18n.t 'components.shopfront.cat_page.cat_sheet.placeholder_description'

  def initialize cat:
    @cat = cat
  end

  attr_reader :cat

  def cat_description
    cat.description.to_s.empty? ? PLACEHOLDER_DESCRIPTION : cat.description
  end
end