# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  # Pick a unique cookie name to distinguish our session data from others'
  #session :session_key => '_copacetic_session_id'
  helper :all
  # include AuthenticatedSystem
  include ActionView::Helpers::SanitizeHelper
  
   # def login_required
   #     if session[:user]
   
   #       return true
   #     end
   #     flash[:warning]='Please login to continue'
   #     session[:return_to]=request.request_uri
   #     redirect_to :controller => "user", :action => "login"
   #     return false 
   #   end
   # 
   #   def current_user
   #     session[:user]
   #   end
   # 
   #   def redirect_to_stored
   #     if return_to = session[:return_to]
   #       session[:return_to]=nil
   #       redirect_to (return_to)
   #     else
   #       redirect_to :controller=>'user', :action=>'welcome'
   #     end
   #   end
   #   
   #   def paginate_by_sql(model, sql, per_page, options={})
   #       if options[:count]
   #           if options[:count].is_a? Integer
   #               total = options[:count]
   #           else
   #               total = model.count_by_sql(options[:count])
   #           end
   #       else
   #           total = model.count_by_sql_wrapping_select_query(sql)
   #       end
   # 
   #       object_pages = Paginator.new self, total, per_page,
   #            @params['page']
   #       objects = model.find_by_sql_with_limit(sql,
   #            object_pages.current.to_sql[1], per_page)
   #       return [object_pages, objects]
   #    end
   
   def frontpage
     @frontitems = Frontitem.all.order(:position)
     @post = Post.published.limit(1).first
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


