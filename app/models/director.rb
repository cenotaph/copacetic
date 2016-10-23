class Director < ActiveRecord::Base
  has_and_belongs_to_many :dvds, :join_table=>'directors_dvds'

  extend FriendlyId
  friendly_id :fullname, :use => :slugged    
  
  scope :by_uniq, -> () { joins(:dvds).uniq }
  def validate_on_create
    exists = Director.find_by(lastname:  lastname)
    unless exists.blank?
        if firstname.blank?
            errors.add_to_base('Director already exists')
        else
            if exists.collect{|x| x.firstname}.include?(firstname)
                errors.add_to_base('Director already exists!')
            end
        end
    end
  end

  def display_title
    fullname
  end
  
  def items
    dvds
  end
  
  def fullname
    if self.firstname.blank?
      return self.lastname
    else
     return self.firstname + " " + self.lastname
    end
  end 

 end
