class Special < ActiveRecord::Base
  has_many :items_specials, :dependent => :delete_all


  has_many :comics, through: :items_specials, source: :item, source_type: 'Comic'
  has_many :books, through: :items_specials, source: :item, source_type: 'Book'
  has_many :cds, through: :items_specials, source: :item, source_type: 'Cd'
  has_many :dvds, through: :items_specials, source: :item, source_type: 'Dvd'      
    
  extend FriendlyId
  friendly_id :name,  :use => :slugged  
  validates_presence_of :name
  #
  # scope :comics, lambda {
  #   joins(:comics).
  #   where("items_specials.item_type" => 'Comic')
  # }
  #
  # scope :books, lambda {
  #   joins(:books).
  #   where("items_specials.item_type" => 'Book')
  # }
  #
  #
  # scope :cds, lambda {
  #   joins(:cds).
  #   where("items_specials.item_type" => 'Cd')
  # }
  #
  #
  # scope :dvds, lambda {
  #   joins(:dvds).
  #   where("items_specials.item_type" => 'Dvd')
  # }
  
  scope :instock_by_special, -> (i) { where(id: i) }
  
  def display_title
    name
  end
  
  def items
    comics + books + dvds + cds
  end
  
  def instock
    items.delete_if{|x| x.instock == false}
  end
  
end
