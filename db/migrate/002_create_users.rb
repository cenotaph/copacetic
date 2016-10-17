class CreateUsers < ActiveRecord::Migration
  def self.up
     rename_column :users, :realname, :name
      rename_column :users, :hashed_password,  :crypted_password
      add_column :users, :updated_at,                :datetime
     add_column :users, :remember_token,            :string, :limit => 40
     add_column :users, :remember_token_expires_at, :datetime
     add_column :users, :activation_code,           :string, :limit => 40
     add_column :users, :activated_at, :datetime
    add_index :users, :login, :unique => true
  end

  def self.down
    drop_table "users"
  end
end
