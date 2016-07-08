module UserMessage

  def user_message key, **interpolatables
    full_message_key = "user_messages.#{ self.class.name.underscore.tr '/', '.' }.#{key}"
    default_message = key.to_s.humanize

    I18n.t full_message_key, default: default_message, **interpolatables
  end

end