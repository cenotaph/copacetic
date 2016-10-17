class CreateItemsCreators < ActiveRecord::Migration
  def self.up
    create_table :items_creators do |t|
      t.integer :item_id
      t.string :item_type
      t.integer :creator_id
    end
    execute("insert into items_creators (item_id, item_type, creator_id) select comic_id, 'Comic', creator_id from creators_comics")
    execute("insert into items_creators (item_id, item_type, creator_id) select book_id, 'Book', creator_id from creators_books")
    Creator.find_each(&:save)
  end

  def self.down
    drop_table :items_creators
  end
end
