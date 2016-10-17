class AddSortorderToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :sortorder, :float
  end
end
