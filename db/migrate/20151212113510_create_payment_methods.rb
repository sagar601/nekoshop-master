class CreatePaymentMethods < ActiveRecord::Migration
  def change
    create_table :payment_methods do |t|
      t.string :type, null: false, default: 'PaymentMethod'
      t.json :card, null: false, default: {}
      t.references :customer, index: true, foreign_key: true
      t.references :checkout, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
