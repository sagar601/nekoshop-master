require 'test_helper'

describe RollPhotos do
  using Augmented::Symbols

  before do
    @photo1 = CatPhoto.new id: 1, image: TestHelpers.dummy_image_file, headshot: true
    @photo2 = CatPhoto.new id: 2, image: TestHelpers.dummy_image_file(1)
    @photo3 = CatPhoto.new id: 3, image: TestHelpers.dummy_image_file(2)

    @unordered_photos = [ @photo2, @photo3, @photo1 ]
  end

  let(:wrapper) { RollPhotos.new(@unordered_photos) }

  it 'returns the processed photos via `to_a`' do
    wrapper.must_respond_to :to_a
    wrapper.to_a.count.must_equal 3
  end

  it 'returns an hash for each photo with id and src only' do
    wrapper.to_a.map(&:[].with(:id)).must_contain [1,2,3]
    wrapper.to_a.map(&:[].with(:src)).compact.count.must_equal 3
  end

  it 'orders the photos by headshot first, then by id, oldest first' do
    wrapper.to_a.map(&:[].with(:id)).must_equal [1,2,3]
  end

  it 'returns empty if no photos are provided' do
    RollPhotos.new([]).to_a.must_be_empty
  end

  it 'works the same without an headshot' do
    @photo1.headshot = false
    wrapper.to_a.map(&:[].with(:id)).must_equal [1,2,3]
  end
end