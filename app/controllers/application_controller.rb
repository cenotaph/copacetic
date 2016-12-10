# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  # Pick a unique cookie name to distinguish our session data from others'
  #session :session_key => '_copacetic_session_id'
  helper :all
  # include AuthenticatedSystem
  include ActionView::Helpers::SanitizeHelper

   
   def frontpage
     @frontitems = Frontitem.all.order(:position)
     @post = Post.published.order(created_at: :desc).limit(1).first
     @selects = Special.friendly.find('copacetic-select').instock.shuffle[0..9]
     render :template => 'shared/frontpage'
   end

  def search
    @items = XapianDb.search params[:query], :page => params[:page],  :per_page => 32
    respond_to do |format|
      format.html { render :template => 'shared/search_results' }
      format.js
    end
  end
end


