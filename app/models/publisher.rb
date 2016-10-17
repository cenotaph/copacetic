class Publisher < ActiveRecord::Base
  has_many  :comics
  has_many  :books
  has_many :dvds

  extend FriendlyId
  friendly_id :name,  :use => :slugged  

  validates_presence_of :name
  

  
  def self.instock_by_publisher(i)
    find(i).instock
  end  
    
  def display_title
    name
  end
  
  def items
    comics + books + dvds
  end
  
  def instock
    items.delete_if{|x| x.instock != true}
  end
  
  def instock?
    instock
  end

  
end
