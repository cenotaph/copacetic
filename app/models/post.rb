class Post < ActiveRecord::Base
  belongs_to :admin_user

  
  extend FriendlyId
  friendly_id :title, :use => :slugged  
  
  validates_presence_of :title
  
  scope :published, ->() { where(:published => true) }
  
  def approved_comments
    self.comments.delete_if{|x| x.approved==false}
  end
  
end
