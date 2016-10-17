class Serial < ActiveRecord::Base
  has_and_belongs_to_many :comics, :join_table => 'serials_comics'

  
  extend FriendlyId
  friendly_id :name,  :use => :slugged  
  validates_presence_of :name

  def self.instock_by_serial(i)
    find(i).instock
  end  

  def display_title
    name
  end
  
  def items
    comics
  end
  
  def instock
    items.delete_if{|x| x.instock == false}
  end
  
    
end
