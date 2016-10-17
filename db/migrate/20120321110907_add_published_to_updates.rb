class AddPublishedToUpdates < ActiveRecord::Migration
  def self.up
    add_column :justins, :published, :boolean
    execute("update justins set published = true")
    add_column :articles, :published, :boolean
    execute("update articles set published = true")
    add_column :posts, :published, :boolean
    execute("update posts set published = true")        
  end

  def self.down
    remove_column :justins, :published
    remove_column :articles, :published
    remove_column :posts, :published      
  end
end
