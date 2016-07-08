class CreateCheckouts < ActiveRecord::Migration
  def change
    create_table :checkouts do |t|
      t.references :cart, index: true, foreign_key: true, null: false
      t.references :customer, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
