class Update < ActiveRecord::Base
  has_many  :comics
  has_many  :books
  has_many  :dvds
  has_many :cds
  
  scope :published, where(:published => true)

  extend FriendlyId
  friendly_id :name, :use => :slugged
  validates_presence_of :name, :day

end
