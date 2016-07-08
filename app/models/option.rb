class Option < ActiveRecord::Base
  default_scope { order('id ASC') }

  belongs_to :cat, inverse_of: :options
  has_many :variations, dependent: :destroy, inverse_of: :option

  validates :cat, presence: true
end
