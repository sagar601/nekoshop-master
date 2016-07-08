class VariationPhoto < ActiveRecord::Base
  include Imageable

  default_scope { order('id ASC') }

  belongs_to :variation, inverse_of: :photo

  validates :variation, presence: true
end
