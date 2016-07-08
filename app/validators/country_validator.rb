class CountryValidator < ActiveModel::EachValidator

  def validate_each record, attribute, value
    return if options[:allow_blank] && value.blank?
    return if options[:allow_nil] && value.nil?

    if ISO3166::Country.new(value).nil?
      record.errors[attribute] << (options[:message] || "is not a recognized country")
    end
  end

end