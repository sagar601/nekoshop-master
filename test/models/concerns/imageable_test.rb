module ImageableTest
  extend Minitest::Spec::DSL

  it 'has an image' do
    subject.must_respond_to :image
    subject.must_respond_to :image=
  end

  it 'returns the URL to the image, ready to go into a view' do
    subject.image = TestHelpers.dummy_image_file
    subject.image.save!

    assert subject.src.length > 0
    assert subject.fallback? == false
  end

  it 'returns a fallback url if there is no image' do
    subject.image = nil

    subject.fallback?.must_equal true
  end

  it 'can tell whether it is a fallback image or not' do
    subject.image = nil

    subject.fallback?.must_equal true

    subject.image = TestHelpers.dummy_image_file
    subject.image.save!

    subject.fallback?.must_equal false
  end

end
