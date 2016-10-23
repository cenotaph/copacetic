class Creator < ActiveRecord::Base

  has_many :items_creators
  # has_many :items, :through => :items_creators
  has_many :comics, through: :items_creators, source: :item, source_type: 'Comic'
  has_many :books, through: :items_creators, source: :item, source_type: 'Book'
    
  scope :comic_creators, ->() { joins(:comics).where("comics.id is not null").uniq }
  scope :book_creators, ->() { joins(:books).where("books.id is not null").uniq }
  
  extend FriendlyId
  friendly_id :fullname,  :use => :slugged  
  # def validate_on_create
  #     exists=Creator.find(:all, :conditions => ['lastname = ?', lastname])
  #     unless exists.blank?
  #         if firstname.blank?
  #             errors.add_to_base('Creator exists')
  #         else
  #             if exists.collect{|x| x.firstname}.include?(firstname)
  #                 errors.add_to_base('Creator already exists!')
  #             end
  #         end
  #     end
  #   end
  
  def items
    comics + books
  end        

  # def items
  #   self.items_creators.collect {|a| a.item }
  # end
  
  def display_title
    fullname
  end
  
  def fullname
    if ((self.firstname != nil) and (self.lastname != nil))
      self.firstname + " " + self.lastname
    else
        self.lastname
    end
  end

end

