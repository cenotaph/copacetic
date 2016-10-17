class AuthenticationsController < ApplicationController  
  def index  
  end  
  
  def handle_unverified_request
    true
  end



  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    if authentication
      flash[:notice] = "Signed in successfully."
      sign_in_and_redirect(:admin_user, authentication.admin_user)
    elsif current_admin_user
      current_admin_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = "Authentication successful."
      redirect_to '/'
    elsif omniauth['provider'] == 'twitter' && user = AdminUser.find_by_username(omniauth['info']['nickname'])
      user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      sign_in_and_redirect(:admin_user, user)
    else
      user = AdminUser.new
      user.apply_omniauth(omniauth)
      if user.save
        flash[:notice] = "Signed in successfully."
        sign_in_and_redirect(:admin_user, user)
      else
        logger.warn('errors are ' + user.errors.inspect)
        session[:omniauth] = omniauth.except('extra')
        redirect_to new_admin_user_registration_url
      end
    end
  end
    
  def destroy  
  end  
  
  def root_path
    '/'
  end
end  