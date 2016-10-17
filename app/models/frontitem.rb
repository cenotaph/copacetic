class Frontitem < ActiveRecord::Base
  belongs_to :item, :polymorphic => true

  
  def self.save_img(item)
      if (item['image'] != nil)
        
       File.open(HOMEPATH+"/public/catalog/frontpage/"+item['image'].original_filename, "w") { 
         |f| f.write(item['image'].read) }
     end
   end
  
end
