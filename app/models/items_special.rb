class ItemsSpecial  < ActiveRecord::Base
    belongs_to :special
    belongs_to :item, :polymorphic => true
    
    belongs_to :comic, :foreign_key => "item_id", :class_name => "Comic"
        
    belongs_to :cd, :foreign_key => "item_id", :class_name => "Cd"
        
    belongs_to :dvd, :foreign_key => "item_id", :class_name => "Dvd"
        
    belongs_to :book, :foreign_key => "item_id", :class_name => "Book"
end