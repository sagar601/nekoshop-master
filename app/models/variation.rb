class Variation < ActiveRecord::Base
  default_scope { order('id ASC') }

  monetize :cost_cents, as: 'cost'

  belongs_to :option, inverse_of: :variations
  has_one :cat, through: :option, inverse_of: :variations
  has_one :photo, dependent: :destroy, class_name: 'VariationPhoto', inverse_of: :variation

  validates :option, presence: true

  def photo
    super || VariationPhoto.new
  end

end
