class Forms::Admin::Cats::CatForm < Reform::Form

  property :name, validates: { presence: true, length: 2..30 }
  property :species, validates: { length: 0..50 }
  property :summary, validates: { length: 0..100 }
  property :description, validates: { length: 0..10000 }
  property :price, validates: { numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10000 } }


  collection :photos, populate_if_empty: ::CatPhoto, skip_if: :destroy_photo do
    property :src, writeable: false
    property :image
    property :headshot
  end

  def destroy_photo attributes, form_options
    if attributes['_destroy'] == '1'
      photos.delete_if { |photo| photo.id.to_s == attributes['id'] }
      true
    end
  end


  collection :options, populate_if_empty: ::Option, prepopulator: :prep_options, skip_if: :all_blank do
    property :name, validates: { presence: true, length: 2..30 }
    property :description, validates: { length: 0..500 }

    collection :variations, populate_if_empty: ::Variation, skip_if: :destroy_variation do
      property :name, validates: { presence: true, length: 1..30 }
      property :cost, validates: { numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 } }
      property :_destroy, virtual: true

      property :photo do
        property :src, writeable: false
        property :image
        property :remove_image
      end
    end

    def destroy_variation attributes, form_options
      if attributes['_destroy'] == '1'
        variations.delete_if { |v| v.id.to_s == attributes['id'] }
        true
      end
    end
  end

  def prep_options form_options
    (::Cat::MAX_OPTIONS_PER_CAT - options.count).times { options << ::Option.new }
  end

end