class AddCreatorCountToComics < ActiveRecord::Migration
  def change
    add_column :comics, :creators_count, :integer, :default => 0
    Comic.unscoped.reset_column_information
    Comic.unscoped.all.each do |comic|
      Comic.unscoped.update_counters(comic.id, :creators_count => comic.creators.count)
    end
    add_column :books, :creators_count, :integer, :default => 0
    Book.unscoped.reset_column_information
    Book.unscoped.all.each do |book|
      Book.unscoped.update_counters(book.id, :creators_count => book.creators.count)
    end

  end
end
