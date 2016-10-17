class MoveImages < ActiveRecord::Migration
  def up
    rename_table :updates, :justins
    rename_column :comics, :update_id, :justin_id
    rename_column :books, :update_id, :justin_id
    rename_column :dvds, :update_id, :justin_id
    rename_column :cds, :update_id, :justin_id            
  end

  def down
    rename_table :justins, :updates
  end    
        

end
