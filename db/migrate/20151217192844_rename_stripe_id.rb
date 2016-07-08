class RenameStripeId < ActiveRecord::Migration
  def change
    rename_column :customers, :stripe_id, :external_id
  end
end
