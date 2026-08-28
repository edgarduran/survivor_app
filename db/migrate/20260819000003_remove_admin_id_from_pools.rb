class RemoveAdminIdFromPools < ActiveRecord::Migration[8.0]
  def change
    remove_column :pools, :admin_id, :integer
  end
end
