class Cd < ActiveRecord::Base
  paginates_per 32
  has_one :frontitem, :as => :item
  belongs_to :label
  has_many :specials, :through => :items_specials
  has_many :items_specials, :as => :item
  mount_uploader :image, ImageUploader
  # default_scope includes(:justin).order("justins.day DESC")
  belongs_to :justin

  extend FriendlyId
  
  before_save :check_front_grid
  attr_accessor :include_front_grid
  friendly_id :display_title,  :use => :slugged
  scope :instock, ->() { where(instock: true) }
  def self.by_special(s)
    joins(:items_specials).where("items_specials.item_type = 'Cd'  and items_specials.special_id = ?", s)
  end 
  
 scope :by_publisher, ->(s) { joins(:publisher).where("cds.publisher_id = ?", s) }
      
  def self.by_creator(s)
    where("artist like '%" + s + "%'")
  end
  

  def sanitise
    self.shortdesc = Sanitize.clean(self.shortdesc,  :elements => ['b', 'em', 'strong', 'a', 'u'], :attributes => {'a' => ['href', 'target', 'title']}, :protocols => {'a' => {'href' => ['http', 'mailto']}} )
#    self.description = Sanitize.clean(self.description,  :elements => ['b', 'em', 'strong', 'a', 'u'], :attributes => {'a' => ['href']}, :protocols => {'a' => {'href' => ['http', 'mailto']}} ) 
  end
  
  def authorship
    "<a href=\"/artists/#{artist}\">#{artist}</a>"
  end
  
  def authorship_short
    authorship
  end
  
  def in_front_grid
    frontitem.nil? ? false : true
  end
  
  def check_front_grid
    if include_front_grid == "1"
      if self.frontitem.nil?
        self.frontitem = Frontitem.new(:position => 1)
      end
    else
      if !self.frontitem.nil?
        self.frontitem.destroy
      end
    end
  end
  
   def combinedname
     if self.title.blank?
       self.artist + " (self-titled)"
     else
       self.title  + " by " + self.artist
     end 
   end
   
   def label_name
     label.blank? ? "" : '<a href="/labels/' + label.slug + '">' + label.name + '</a>'.html_safe
   end
   
   def label_name=(name)
     self.label = Label.find_or_create_by(name: name.strip)
   end 
    
   def icon
     if self.image.blank?
       return "/images/missing_image.png"
     else
       return  "/catalog/cds/" + self.image
     end
   end

   def display_title 
     if self.title.blank?
       return self.artist
     else
       return self.title + " by " + self.artist
     end
   end

  def issuer_credit
    label.blank? ? "" :   "released by #{label_name}".html_safe
  end
  
   def others
     if self.artist.nil?
       return ""
     else
       others = Cd.find_all_by_artist(self.artist, :order => 'cds.id DESC').delete_if{
            |x| x == self }
       others += Cd.find(:all, :include => :label, :conditions => ['label_id = ?', self.label.id], :order => "cds.id DESC")
       
       
       return others.delete_if{|x| x == self }.sort{|x,y| y.id <=> x.id}.uniq
     end
   end

  def title_with_issue
    combinedname
  end
end
# XapianDb::DocumentBlueprint.setup(:Cd) do |blueprint|
#   blueprint.attribute :title, :weight => 9
#   blueprint.attribute :artist, :weight => 10
#   blueprint.attribute :label_name, :weight => 3
#   blueprint.index :description, :weight => 2
#   blueprint.attribute :shortdesc, :weight => 2
# end