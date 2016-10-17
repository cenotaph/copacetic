class CreateRoles < ActiveRecord::Migration
  def self.up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
    execute('INSERT INTO roles (name) VALUES("SuperAdmin")')
    execute('INSERT INTO roles (name) VALUES("InventoryAdmin")')
    execute('INSERT INTO roles (name) VALUES("ContentAdmin")')    
    create_table :roles_admin_users, :id => false do |t|
      t.references :role, :admin_user
    end
  end

  def self.down
    drop_table :roles
    drop_table :roles_admin_users
  end
end
