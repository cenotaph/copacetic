class AddSlugs < ActiveRecord::Migration
  def self.up
    add_column :comics, :slug, :string, :null => false, :unique => true
    add_index :comics, :slug
    add_column :books, :slug, :string, :null => false, :unique => true
    add_index :books, :slug
    add_column :cds, :slug, :string, :null => false, :unique => true
    add_index :cds, :slug
    add_column :dvds, :slug, :string, :null => false, :unique => true
    add_index :dvds, :slug
    add_column :publishers, :slug, :string, :null => false, :unique => true
    add_index :publishers, :slug
    add_column :directors, :slug, :string, :null => false, :unique => true
    add_index :directors, :slug
    add_column :creators, :slug, :string, :null => false, :unique => true
    add_index :creators, :slug
    add_column :labels, :slug, :string, :null => false, :unique => true
    add_index :labels, :slug
    add_column :specials, :slug, :string, :null => false, :unique => true
    add_index :specials, :slug
    add_column :articles, :slug, :string, :null => false, :unique => true
    add_index :articles, :slug
    add_column :serials, :slug, :string, :null => false, :unique => true
    add_index :serials, :slug
    add_column :posts, :slug, :string, :null => false, :unique => true
    add_index :posts, :slug
    add_column :justins, :slug, :string, :null => false, :unique => true
    add_index :justins, :slug   
    
  end

  def self.down
    drop_column :comics, :slug
    drop_column :books, :slug
    drop_column :cds, :slug
    drop_column :dvds, :slug
    drop_column :publishers, :slug                
    drop_column :directors, :slug
    drop_column :creators, :slug
    drop_column :labels, :slug
    drop_column :specials, :slug
    drop_column :articles, :slug
    drop_column :posts, :slug                                  
    drop_column :serials, :slug
    drop_column :justins, :slug
  end
end
