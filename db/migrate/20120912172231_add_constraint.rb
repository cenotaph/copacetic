class AddConstraint < ActiveRecord::Migration
  def up
     execute "alter table articles change quotidian quotidian boolean not null default false"
     execute "alter table articles change in_universe in_universe boolean not null default false"
  end

  def down
    
  end
end
