class AddAdminFlagToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin_flag, :integer
  end
end
