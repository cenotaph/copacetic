class RemoveExtraFields < ActiveRecord::Migration
  def self.up
    remove_column :creators_comics, :description
    remove_column :specials_comics, :description
    remove_column :directors_dvds, :description
  end

  def self.down
  end
end
