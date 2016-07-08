class Cat < ActiveRecord::Base
  MAX_OPTIONS_PER_CAT = 3

  default_scope { order('id ASC') }

  has_many :options, dependent: :destroy, inverse_of: :cat
  has_many :variations, through: :options, inverse_of: :cat
  has_many :virtual_cats, dependent: :destroy, inverse_of: :cat

  after_save :sync_virtual_cats!

  has_many :photos, dependent: :destroy, class_name: 'CatPhoto', inverse_of: :cat
  has_one :headshot, -> { headshot }, class_name: 'CatPhoto'

  validates :name, uniqueness: true
  validates :photos, cap: 20
  validates :options, cap: MAX_OPTIONS_PER_CAT
  validates :variations, cap: 50

  monetize :price_cents, as: 'price'

  def headshot
    super || CatPhoto.new
  end

  def available?
    virtual_cats.any? &:available?
  end

  def stock
    virtual_cats.map(&:stock).reduce(0, :+)
  end

  def sync_virtual_cats!
    transaction do
      current = virtual_cats.map &:vcid
      goal = Vcid.build_all_combinations options

      to_add = goal - current
      to_delete = current - goal

      to_add.each{ |vcid| virtual_cats.create! vcid: vcid }

      virtual_cats.select{ |vcat| to_delete.include? vcat.vcid }.each &:destroy!
    end
  end

end