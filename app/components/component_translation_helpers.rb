module ComponentTranslationHelpers

  private

  def t key, interpolations = {}
    @_translation_class_key_prefix ||= self.class.name.underscore.tr('/','.')

    I18n.t @_translation_class_key_prefix + key, interpolations
  end

end