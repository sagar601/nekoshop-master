class CreateCustomerCartsAndVirtualCats < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.references  :user,      index: true, foreign_key: true, null: false
      t.string      :stripe_id
      t.json        :address,   null: false, default: {}

      t.timestamps null: false
    end

    create_table :carts do |t|
      t.references :customer, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end

    create_table :virtual_cats do |t|
      t.references  :cat,           index: true, foreign_key: true, null: false
      t.integer     :stock,         null: false, default: 0
      t.text        :variation_ids

      t.timestamps null: false
    end

    create_table :cart_items do |t|
      t.references  :cart,        index: true, foreign_key: true, null: false
      t.references  :virtual_cat, index: true, foreign_key: true, null: false
      t.integer     :quantity,    null: false, default: 0

      t.timestamps null: false
    end

  end
end