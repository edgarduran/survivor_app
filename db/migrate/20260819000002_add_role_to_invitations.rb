class AddRoleToInvitations < ActiveRecord::Migration[8.0]
  def change
    add_column :invitations, :role, :string, null: false, default: "member"
  end
end
