# -*- encoding : utf-8 -*-
class Authentication < ActiveRecord::Base
  belongs_to :admin_user  
end
