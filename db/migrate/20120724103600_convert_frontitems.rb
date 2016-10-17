class ConvertFrontitems < ActiveRecord::Migration
  def up
    rename_column :frontitems, :category, :item_type
    change_column :frontitems, :item_type, :string
    execute("UPDATE frontitems SET item_type = 'Comic' WHERE item_type = '1'")
    execute("UPDATE frontitems SET item_type = 'Book' WHERE item_type = '2'")
    execute("UPDATE frontitems SET item_type = 'Dvd' WHERE item_type = '3'")
    execute("UPDATE frontitems SET item_type = 'Cd' WHERE item_type = '4'") 
    rename_column :frontitems, :original_id, :item_id   
  end

  def down
  end
end
