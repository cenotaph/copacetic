class Book < ActiveRecord::Base
  paginates_per 32
  extend FriendlyId
  friendly_id :title_with_issue, use: :slugged
  has_one :frontitem, :as => :item  
  belongs_to :publisher
  validates_presence_of :publisher_id
  
  mount_uploader :image, ImageUploader
  
  has_many :creators, :through => :items_creators
  has_many :items_creators, :as => :item
  
  # belongs_to :stockupdate, :class_name => 'Justin', :foreign_key => "justin_id"
  
  has_many :specials, :through => :items_specials
  has_many :items_specials, :as => :item
  
  accepts_nested_attributes_for :creators, :allow_destroy => true, :reject_if => lambda { |a| a[:firstname].blank? }
  accepts_nested_attributes_for :specials
  validates_presence_of :slug, :title
  # default_scope includes(:justin).order("justins.day DESC")
  belongs_to :justin
  before_save :check_front_grid
  attr_accessor :include_front_grid

  def self.by_special(s)
    joins(:items_specials).where("items_specials.item_type = 'Book'  and items_specials.special_id = ?", s)
  end 
  
  scope :instock, ->() { where(instock: true) }
  scope :by_publisher, -> (s) { joins(:publisher).where("books.publisher_id = ?", s) }
      
  def self.by_creator(s)
    if s =~ /\w+\s\w+/
      names = s.split(/\s/)
      if names.size > 1
        joins(:creators).where("creators.firstname like '%" + names.first + "%' AND creators.lastname LIKE '%" + names[1] + "%'").order('creators_count ASC, justins.day DESC')
      end
    else
      joins(:creators).where("creators.firstname like '%" + s + "%' OR creators.lastname LIKE '%" + s + "%'").order('creators_count Asc, justins.day DESC')
    end
  end

  def autosave_associated_records_for_creators
    creators.each do |creator|
      if creator.id.nil?
        new_creator = Creator.find_or_create_by(firstname: creator.firstname, lastname: creator.lastname) unless creator.firstname.blank? || creator.marked_for_destruction?
        creator.id = new_creator.id
        self.creators << new_creator
      elsif creator.changed_for_autosave? && !creator.marked_for_destruction?
        new_creator = Creator.find(creator.id)
        new_creator.firstname = creator.firstname
        new_creator.lastname = creator.lastname
        new_creator.save!
      elsif creator.marked_for_destruction?
        self.creators.delete(creator)
      end

    end

   end
   
  
    def authorship
      creators.map{|x| '<a href="/creators/' + x.slug + '">' +  x.fullname + '</a>'}.join(', ')
    end
    
    def authorship_short
      creators.size > 2 ? creators[0..1].map{|x| '<a href="/creators/' + x.slug + '">' +  x.fullname + '</a>'}.join(', ') + " + #{creators.size - 2 } more" : authorship
    end
    
    def sanitise
      self.shortdesc = Sanitize.clean(self.shortdesc,  :elements => ['b', 'em', 'strong', 'a', 'u'], :attributes => {'a' => ['href', 'target', 'title']}, :protocols => {'a' => {'href' => ['http', 'mailto']}} )
#      self.description = Sanitize.clean(self.description,  :elements => ['b', 'em', 'strong', 'a', 'u'], :attributes => {'a' => ['href']}, :protocols => {'a' => {'href' => ['http', 'mailto']}} ) 
    end
    
     def combinedname
        if self.creators.nil?
          self.title
        else
            self.title + ' by ' + self.creator_names
        end
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
  def creator_alone
    creators.size == 1 ?  creators.first.fullname : nil
  end
  
      
      
  def creator_names
      creators.collect{|x| x.fullname }.join(', ') if creators
  end

    def creator_names=(name)
       self.creators = []

       if name =~ /\,/
         names = name.split(/\,/)
         names.each do |n|
           if n.strip =~ /\s/
               pieces = n.split
               self.creators << Creator.find_or_create_by(firstname: pieces[0].strip, lastname:
               pieces[2] ? 
               pieces[1].strip + " " + pieces[2].strip : 
               pieces[1].strip)
           else
               self.creators << Creator.find_or_create_by(lastname: n.strip)
           end   
         end
       elsif name.blank?
         self.creators = []
        else
           if name.strip  =~ /\s/
               pieces = name.split
               self.creators << Creator.find_or_create_by(firstname: pieces[0].strip, lastname: pieces[2] ? pieces[1] + " " + pieces[2].strip : pieces[1].strip)
           else
               self.creators << Creator.find_or_create_by(lastname: name.strip)
           end
       end

     end
     
  def display_title
    title
  end
     def icon
        if self.image.blank?
          return "/images/missing_image.png"
        else
          return  "/catalog/books/" + self.image
        end
      end
    
      
  def others
    if self.creators.nil?
      return ""
    else
      others = []
      self.creators.each do |creator|
        others += creator.books.to_a.delete_if{|x| x==self}
      end
      return others.sort{|x,y| y.id <=> x.id}.uniq
    end
  end
      
  def publisher_name
    self.publisher.name if publisher
  end

  def publisher_name=(name)
    self.publisher = Publisher.find_or_create_by(name: name)
  end
  
  def issuer_credit
    publisher.blank? ? "" : "published by <a href=\"/publishers/#{publisher.slug}\">#{publisher_name}</a>".html_safe
  end    
  
  def title_with_issue 
    if self.creator_names.blank?
      return self.title
    else
      return self.title + " by " + self.creator_names
    end
  end  
   
end
# XapianDb::DocumentBlueprint.setup(:Book) do |blueprint|
#   blueprint.attribute :title, :weight => 10
#   blueprint.attribute :creator_alone, :weight => 9
#   blueprint.attribute :creator_names, :weight => 5
#   blueprint.attribute :publisher_name, :weight => 3
#   blueprint.index :description, :weight => 2
#   blueprint.attribute :shortdesc, :weight => 2
# end