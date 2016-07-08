class RollPhotos
  using Augmented::Objects

  def initialize cat_photos
    @photos = pick sort cat_photos.to_a
  end

  def to_a
    @photos
  end

  private

  def sort photos
    headshot = photos.find &:headshot
    rest = photos - [headshot]
    rest.sort!

    [headshot, *rest].compact
  end

  def pick photos
    photos.pick :id, :src
  end
end