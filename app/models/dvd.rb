class Dvd < ActiveRecord::Base

  has_many :directors, :through => :directors_dvds
  has_many :directors_dvds,  :dependent => :delete_all
  # has_and_belongs_to_many :comments, :join_table => 'comments_dvds'
  has_many :specials, :through => :items_specials
  has_many :items_specials, :as => :item
  mount_uploader :image, ImageUploader  
  belongs_to :publisher
  # default_scope includes(:justin).order("justins.day DESC")
  belongs_to :justin
  accepts_nested_attributes_for :directors, :allow_destroy => true, :reject_if => lambda { |a| a[:firstname].blank? }
  accepts_nested_attributes_for :specials
  has_one :frontitem, :as => :item
  extend FriendlyId
  friendly_id :title,  :use => :slugged  
  validates_presence_of :title
  before_save :check_front_grid
  attr_accessor :include_front_grid  
  
  scope :instock, ->() { where(instock: true) }
  
  def self.by_special(s)
    joins(:items_specials).where("items_specials.item_type = 'Dvd'  and items_specials.special_id = ?", s)
  end 
  scope :by_publisher, ->(s)  {joins(:publisher).where("dvds.publisher_id = ?", s) }
       
      
  scope :by_director, ->(s) {
    if s =~ /\w+\s\w+/
      names = s.split(/\s/)
      if names.size > 1
        joins(:directors).where("directors.firstname like '%" + names.first + "%' OR directors.lastname LIKE '%" + names[1] + "%'").uniq
      end
    else
      joins(:directors).where("directors.firstname like '%" + s + "%' OR directors.lastname LIKE '%" + s + "%'").uniq
    end
  }


  
  def authorship
    'Directed by: ' + directors.map{|x| '<a href="/directors/' + x.slug + '">' +  x.fullname + '</a>' }.join(', ')
  end
  
  def authorship_short
    directors.size > 2 ? directors[0..1].map{|x| '<a href="/directors/' + x.slug + '">' +  x.fullname + '</a>' }.join(', ') + " + #{directors.size} more" : authorship
  end

   def sanitise
     self.shortdesc = Sanitize.clean(self.shortdesc,  :elements => ['b', 'em', 'strong', 'a', 'u'], :attributes => {'a' => ['href', 'target', 'title']}, :protocols => {'a' => {'href' => ['http', 'mailto']}} )
#     self.description = Sanitize.clean(self.description,  :elements => ['b', 'em', 'strong', 'a', 'u'], :attributes => {'a' => ['href']}, :protocols => {'a' => {'href' => ['http', 'mailto']}} ) 
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
   def director_names
       directors.collect{|x| x.fullname }.join(', ') if directors
   end
  
  def director_alone
    directors.size == 1 ?  directors.first.fullname : nil
  end
  
  def director_names=(name)
       self.directors = []

       if name =~ /\,/
           names = name.split(/\,/)
           names.each do |n|
             if n.strip =~ /\s/
                 pieces = n.split
                 self.directors << Director.find_or_create_by(firstname: pieces[0].strip, lastname: 
                 pieces[2] ? 
                 pieces[1].strip + " " + pieces[2].strip : 
                 pieces[1].strip)
             else
                 self.directors << Director.find_or_create_by(lastname: n.strip)
             end   
           end
       elsif name.blank?
          self.directors = []
        else
           if name.strip  =~ /\s/
               pieces = name.split
               self.directors << Director.find_or_create_by(firstname: pieces[0].strip, lastname: pieces[2] ? pieces[1] + " " + pieces[2].strip : pieces[1].strip)
           else
                self.directors << Director.find_or_create_by(lastname: name.strip)
           end
       end
   end
    
   
   def combinedname
     if self.directors.nil?
       self.title 
     else
       self.title + " by " + self.director_names
     end
   end
   def icon
     if self.image.blank?
       return "/images/missing_image.png"
     else
       return  "/catalog/dvds/" + self.image
     end
   end

   def title_with_issue 
     title
   end
  
  def display_title
    title_with_issue
  end

  
  def issuer_credit
    publisher.blank? ? "" : "published by <a href=\"/publishers/#{publisher.slug}\">#{publisher_name}</a>".html_safe
  end
      
   def others
     if self.directors.nil?
       return ""
     else
       others = []
       self.directors.each do |director|
         others += director.dvds.to_a.delete_if{|x| x== self }.sort_by(&:id)
        end
          unless self.publisher.blank?
          others += self.publisher.dvds.to_a.delete_if{|x| x== self }.sort_by(&:id)
          end

       return others.uniq
     end
   end
   
   def publisher_name
       self.publisher.name if publisher
   end

   def publisher_name=(name)
     self.publisher = Publisher.find_or_create_by(name: name)
   end
   
   
end
# XapianDb::DocumentBlueprint.setup(:Dvd) do |blueprint|
#   blueprint.attribute :title, :weight => 10
#   blueprint.attribute :director_alone, :weight => 9
#   blueprint.attribute :director_names, :weight => 5
#   blueprint.attribute :publisher_name, :weight => 3
#   blueprint.index :description, :weight => 2
#   blueprint.attribute :shortdesc, :weight => 2
# end