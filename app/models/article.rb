class Article < ActiveRecord::Base
  extend FriendlyId
  friendly_id :title,  :use => :slugged
  validates_presence_of :title

  scope :published, ->()  { where(:published => true).order(:sortorder) }
  scope :copacetica, ->() { where(:published => true).where("quotidian <> 1").where(:in_universe => false).order(:sortorder) }
  scope :universe,  ->() { where(:published => true, :in_universe => false) }
end
