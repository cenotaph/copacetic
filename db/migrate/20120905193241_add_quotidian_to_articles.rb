class AddQuotidianToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :quotidian, :boolean
  end
end
