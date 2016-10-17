class ChangeNameToRealname < ActiveRecord::Migration
  def self.up
    rename_column :users, :name, :real_name
  end

  def self.down
  end
end
