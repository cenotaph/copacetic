class AddUsernameToAdminUsers < ActiveRecord::Migration
  def self.up
    add_column :admin_users, :username, :string
    add_column :admin_users, :real_name, :string
    add_column :admin_users, :about_me, :text
    add_column :admin_users, :location, :string
    add_column :admin_users, :website, :string
  end

  def self.down
    remove_column :admin_users, :website
    remove_column :admin_users, :location
    remove_column :admin_users, :about_me
    remove_column :admin_users, :real_name
    remove_column :admin_users, :username
  end
end
