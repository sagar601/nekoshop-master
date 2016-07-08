class CreateOrdersAndItems < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :customer,     index: true, foreign_key: true, null: false
      t.string :charge_id
      t.string :state,            null: false, default: 'created'
      t.json :address,            null: false, default: {}
      t.monetize :shipping_cost,  null: false, default: 0
      t.monetize :total,          null: false, default: 0

      t.timestamps null: false
    end

    create_table :order_items do |t|
      t.references :order,      index: true, foreign_key: true, null: false
      t.string :name,           null: false
      t.string :variations,     array: true, default: []
      t.integer :quantity,      null: false
      t.monetize :base_price,   null: false, default: 0
      t.monetize :options_cost, null: false, default: 0
      t.integer :virtual_cat_id

      t.timestamps null: false
    end
  end
end