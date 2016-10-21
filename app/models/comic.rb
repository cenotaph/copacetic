class Comic < ActiveRecord::Base
  paginates_per 32
  has_and_belongs_to_many :serials, :join_table => 'serials_comics'
  has_many :creators, :through => :items_creators
  has_many :items_creators, :as => :item, :dependent => :delete_all
  belongs_to :justin
  has_one :frontitem, :as => :item
  
  extend FriendlyId
  friendly_id :title_with_issue,  :use => :slugged
  
  before_save :check_front_grid
  has_many :specials, :through => :items_specials 
  
  has_many :items_specials, :as => :item
  
  has_one :frontitem, :as => :item
  belongs_to :publisher
  validates_presence_of :publisher
  # has_and_belongs_to_many :comments, :join_table => 'comments_comics'

  # default_scope includes(:justin).order("justins.day DESC")
  mount_uploader :image, ImageUploader
  
  accepts_nested_attributes_for :creators, :allow_destroy => true, :reject_if => lambda { |a| a[:firstname].blank? }

   
  accepts_nested_attributes_for :specials
  accepts_nested_attributes_for :serials

  # attr_accessible :image, :include_front_grid, :remove_image, :image_cache, :title, :issue, :publisher_id, :special_ids, :serial_ids, :creators_attributes, :remove_image, :tinydesc, :shortdesc, :description, :pagecount, :dimensions, :weight, :listprice, :price, :instock, :justin_id
  attr_accessor :include_front_grid
  # default_scope includes(:justin).order("justins.day DESC")
  scope :instock, ->() { where(instock: true) }
  
  def self.by_special(s)
    joins(:items_specials).where("items_specials.item_type = 'Comic'  and items_specials.special_id = ?", s)
  end 
  def self.by_serial(s)
    joins(:serials).where("serials.id = ?", s)
  end
      
  def self.by_creator(s)
    if s =~ /\w+\s\w+/
      names = s.split(/\s/)
      if names.size > 1
         unscoped.joins([:justin, :creators]).where("creators.firstname like '%" + names.first + "%' AND creators.lastname LIKE '%" + names[1] + "%'").order('creators_count ASC, justins.day DESC')
      end
    else
        unscoped.joins([:justin, :creators]).where("creators.firstname like '%" + s + "%' OR creators.lastname LIKE '%" + s + "%'").order('creators_count Asc, justins.day DESC')
    end
    
  end
  
  def in_front_grid
    frontitem.nil? ? false : true
  end
  # 
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

  scope :by_publisher, lambda {|s| joins(:publisher).where("comics.publisher_id = ?", s) }
  
  def creator_names
    creators.sort{|x,y| y.items.size <=> x.items.size }.collect{|x| x.fullname }.join(', ') if creators
  end
  
  def creator_alone
    creators.size == 1 ?  creators.first.fullname : ""
  end
  

  
  
  def autosave_associated_records_for_creators
    creators.each do |creator|
      if creator.id.nil?
        new_creator = Creator.find_or_create_by(firstname: creator.firstname, lastname: creator.lastname) unless creator.firstname.blank? || creator.marked_for_destruction?
        creator.id = new_creator.id
        self.creators << new_creator
      elsif creator.changed_for_autosave? && !creator.marked_for_destruction?
        logger.warn('changed for autosave: ' + creator.inspect)
        new_creator = Creator.find(creator.id)
        new_creator.firstname = creator.firstname
        new_creator.lastname = creator.lastname
        new_creator.save!
      elsif creator.marked_for_destruction?
        logger.warn('marked for destruction: ' + creator.inspect)
        self.creators.delete(creator)
      end
  
    end
  
   end
  # def remove_image!
  #   begin
  #     super
  #   rescue Fog::Storage::Rackspace::NotFound
  #   end
  # end
  # 
  # # Override to silently ignore trying to remove missing
  # # previous avatar when saving a new one.
  # def remove_previously_stored_image
  #   begin
  #     super
  #   rescue Fog::Storage::Rackspace::NotFound
  #     @previous_model_for_image = nil
  #   end
  # end  
  
  def display_title
    title_with_issue 
  end
  
  def authorship
    creators.map{|x| '<a href="/creators/' + x.slug + '">' + x.fullname + '</a>' }.join(', ')
  end
  
  def authorship_short
    creators.size > 2 ? creators[0..1].map{|x| '<a href="/creators/' + x.slug + '">' +  x.fullname + '</a>'}.join(', ') + " + #{creators.size - 2 } more" : authorship
  end
      
  def sanitise
    self.shortdesc = Sanitize.clean(self.shortdesc,  :elements => ['b', 'em', 'strong', 'a', 'u'], :attributes => {'a' => ['href', 'target', 'title']}, :protocols => {'a' => {'href' => ['http', 'mailto']}} )
   # self.description = Sanitize.clean(self.description,  :elements => ['b', 'em', 'strong', 'a', 'u'], :attributes => {'a' => ['href']}, :protocols => {'a' => {'href' => ['http', 'mailto']}} ) 
  end
  
  def self.find_common_artists
    find_by_sql("select id, firstname, lastname from creators where id in (select creator_id from creators_comics group by creator_id  having count(*) >= 2) order by lastname")
  end
    
  def publisher_name
      self.publisher.name if publisher
  end
  
  def issuer_credit
    publisher.blank? ? "" : "published by <a href=\"/publishers/#{publisher.slug}\">#{publisher_name}</a>".html_safe
  end
  
  def serial_name
      self.serials.collect{|x| x.name }.join(', ') if serials
  end
  
  def serial_name=(name)
    self.serials = []
    if name =~ /\,/
      names = name.split(/\,/)
      names.each do |n|
            self.serials << Serial.find_or_create_by(name: n.strip)
      end
    else
      self.serials << Serial.find_or_create_by(name: name.strip)
    end  
  end
  

  

  

  
  def combinedname
    if self.issue.blank?
      return self.title + " by " + self.creator_names
    else
      if self.issue =~ /^\d/
        return self.title + ' #' + self.issue + ' by ' + self.creator_names
      else
        return self.title + " by " + self.creator_names
      end
    end
  end
  

  def icon
    if self.image.blank?
      return "/images/missing_image.png"
    else
      return  "/catalog/comics/" + self.image
    end
  end

  
  def others
    if self.creators.nil?
      return ""
    else
      others = []
      self.creators.each do |creator|
        others += creator.comics.to_a.delete_if{|x| x == self }
      end
      return others.sort{|x,y| y.id <=> x.id}.uniq
    end
  end
  
  def publisher_name=(name)
    self.publisher = Publisher.find_or_create_by(name: name)
  end  
  
  def title_with_issue 
    if self.issue.blank?
      return self.title
    else
      return self.title + " #" + self.issue
    end
  end
          
end

# XapianDb::DocumentBlueprint.setup(:Comic) do |blueprint|
#   blueprint.attribute :title, :weight => 10
#   blueprint.attribute :creator_alone, :weight => 9
#   blueprint.attribute :creator_names, :weight => 5
#   blueprint.attribute :publisher_name, :weight => 3
#   blueprint.index :description
#   blueprint.attribute :shortdesc, :weight => 2
# end
