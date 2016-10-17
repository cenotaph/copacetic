class AddBlurbToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :blurb, :text
    add_column :articles, :published, :boolean, :null => false, :default => false
    add_column :posts, :published, :boolean, :null => false, :default => false    
    execute("UPDATE articles SET published = true")
    execute("UPDATE posts SET published = true")    
  end

  def self.down
    remove_column :articles, :blurb
    remove_column :articles, :published
    remove_column :posts, :published
  end
end
