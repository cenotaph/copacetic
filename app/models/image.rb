class Image < ActiveRecord::Base
  has_one :comics
  has_one :dvds
  has_one :books
  has_one :cds
  
  def self.save(item, all)
     if (item['image'] != nil)
      File.open(RAILS_ROOT + "/public/catalog/"+ all + "/" + item['image'].original_filename, "w") { |f| f.write(item['image'].read) }
    end
  end
  
end
