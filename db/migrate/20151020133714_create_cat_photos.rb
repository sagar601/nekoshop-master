class CreateCatPhotos < ActiveRecord::Migration
  def change
    create_table :cat_photos do |t|
      t.references :cat, index: true, foreign_key: true, null: false
      t.boolean :headshot, default: false, null: false, index: true
      t.string :image_uid

      t.timestamps null: false
    end
  end
end
