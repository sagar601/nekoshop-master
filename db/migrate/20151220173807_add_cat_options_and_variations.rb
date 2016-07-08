class AddCatOptionsAndVariations < ActiveRecord::Migration

  def change
    create_table :options do |t|
      t.references :cat, index: true, foreign_key: true, null: false
      t.string :name, null: false, limit: 100
      t.text :description

      t.timestamps null: false
    end

    create_table :variations do |t|
      t.references :option, index: true, foreign_key: true, null: false
      t.string :name, null: false, limit: 100
      t.monetize :cost

      t.timestamps null: false
    end

    create_table :variation_photos do |t|
      t.references :variation, index: true, foreign_key: true, null: false
      t.string :image_uid

      t.timestamps null: false
    end

    remove_column :virtual_cats, :variation_ids, :text
    add_column :virtual_cats, :vcid, :integer, array: true, default: []
  end

end