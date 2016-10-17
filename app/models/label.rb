class Label < ActiveRecord::Base
  has_many :cds

  extend FriendlyId
  friendly_id :name,  :use => :slugged  
  
  validates_presence_of :name

  def items
    cds
  end
  
  def display_title
    name
  end
end
