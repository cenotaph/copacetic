class AdminUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable
  has_many :authentications    
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable


  # Setup accessible (or protected) attributes for your model
  attr_accessor :email, :password, :password_confirmation, :remember_me
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable


  # Setup accessible (or protected) attributes for your model

  has_and_belongs_to_many :roles, :join_table => 'admin_users_roles'
  
  def apply_omniauth(omniauth)
    if omniauth['provider'] == 'twitter'
      self.username = omniauth['info']['nickname']
      self.real_name = omniauth['info']['name']
      self.real_name.strip!
      self.location = omniauth['info']['location']
      self.about_me = omniauth['info']['description']
      self.website = omniauth['info']['urls']['Website'] if website.blank?
    elsif omniauth['provider'] == 'facebook'
      self.email = omniauth['info']['email'] if email.blank?
      self.username = omniauth['info']['nickname']
      self.real_name = omniauth['info']['first_name'] + ' ' + omniauth['info']['last_name']
      self.real_name.strip!
      # self.location = omniauth['extra']['user_hash']['location']['name'] if location.blank?
    end
    self.email = omniauth['info']['email'] if email.blank?
    authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
  end  
  
  def password_required?
    (authentications.empty? || !password.blank?) && super
  end
  
  def role?(role)
      return !!self.roles.find_by_name(role.to_s.camelize)
  end
    
    
  def name
    email
  end
  
end
