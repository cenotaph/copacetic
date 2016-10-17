class AddInuniverseToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :in_universe, :boolean
  end
end
