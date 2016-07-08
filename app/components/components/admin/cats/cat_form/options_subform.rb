class Components::Admin::Cats::CatForm::OptionsSubform

  def initialize form:, parent:
    @form = form
    @parent_form_builder = parent
  end

  attr_reader :form, :parent_form_builder

end