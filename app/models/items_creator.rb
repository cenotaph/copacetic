class ItemsCreator  < ActiveRecord::Base
    belongs_to :creator
    belongs_to :item, :polymorphic => true
    belongs_to :comic, :foreign_key => "item_id", :class_name => "Comic", :counter_cache => :creators_count
    belongs_to :book, :foreign_key => "item_id", :class_name => "Book", :counter_cache => :creators_count
    
    
end