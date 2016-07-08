module Imageable
  extend ActiveSupport::Concern

  FALLBACK_IMAGE_URL = '/images/noimage.png'

  included do
    extend Dragonfly::Model::Validations

    dragonfly_accessor :image
    validates_size_of  :image, maximum: 10.megabytes, if: :image_changed?
    validates_property :format, of: :image, in: ['jpeg', 'png', 'gif'], if: :image_changed?
  end

  def src
    return FALLBACK_IMAGE_URL if image.nil?

    src = begin
      image.remote_url
    rescue NoMethodError, NotImplementedError
      image.url
    end

    src.to_s.empty? ? FALLBACK_IMAGE_URL : src
  end

  def fallback?
    src == FALLBACK_IMAGE_URL
  end

end