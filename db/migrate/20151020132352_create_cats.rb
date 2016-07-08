class CreateCats < ActiveRecord::Migration
  def change
    create_table :cats do |t|
      t.string :name, null: false, limit: 100
      t.string :species, limit: 100, index: true
      t.string :summary, limit: 200
      t.text :description
      t.monetize :price

      t.timestamps null: false
    end

    add_index :cats, :name, unique: true
  end
end
