class CatPhoto < ActiveRecord::Base
  include Imageable

  default_scope { order('id ASC') }

  belongs_to :cat, inverse_of: :photos
  scope :headshot, -> { where headshot: true }

  validates :cat, presence: true
end