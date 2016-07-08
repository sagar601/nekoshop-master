class CapValidator < ActiveModel::EachValidator

  def validate_each record, attribute, value
    limit = options.fetch(:with) { raise ArgumentError, 'needs the limit number' }

    if value.size > limit
      record.errors[:base] << error_message(limit, record, attribute)
    end
  end

  private

  def error_message *metadata
    message % interpolatables(*metadata)
  end

  def message
    options[:message] || I18n.t('validators.cap.message', default: '%{model} can only have a maximum of %{limit} %{attribute}')
  end

  def interpolatables limit, record, attribute
    {
      limit: limit,
      model: record.model_name.human,
      attribute: record.class.human_attribute_name(attribute)
    }
  end

end