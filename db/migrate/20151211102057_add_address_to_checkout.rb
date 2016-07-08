class AddAddressToCheckout < ActiveRecord::Migration
  def change
    add_column :checkouts, :address, :json, null: false, default: {}
  end
end
