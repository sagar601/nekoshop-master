class Components::Admin::Cats::DeleteCatButton
  include ComponentTranslationHelpers

  def initialize cat:
    @cat = cat
  end

  attr_reader :cat

  def button_text
    t '.delete', cat_name: @cat.name
  end

  def confirm_message
    t '.are_you_sure', cat_name: @cat.name
  end

end