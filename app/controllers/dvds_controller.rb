class DvdsController < InheritedResources::Base
  has_scope :by_special
  has_scope :by_publisher
  has_scope :by_director

  def auto_complete_for_dvd_director_names
    search = params[:dvd][:director_names]
    @directorsearch = Creator.find(:all, :conditions => ["(lower(lastname) LIKE lower(?)) OR (lower(firstname) LIKE lower(?))", "%#{search}%", "%#{search}%"], :order => 'lastname') unless search.blank?
    logger.warn("directorsearch is " + @directorsearch.inspect)
    render :partial => "directorsearch" 
  end

 def auto_complete_for_dvd_publisher_name
    @publishersearch = Publisher.find(:all, :conditions => ["lower(name) like lower(?)", "%#{params[:dvd][:publisher_name]}%"])
    render :partial => "publishersearch"
 end
      
  def auto_complete_for_dvd_serial_name
     @publishersearch = Serial.find(:all, :conditions => ["lower(name) like lower(?)", "%#{params[:dvd][:serial_name]}%"])
     render :partial => "publishersearch"
  end
 
  def index
    set_meta_tags :title => 'Film and Video'
    @featured = Special.find_by(name: 'FEATURED ITEM').dvds.order(updated_at: :desc)
    @publishers = Publisher.joins(:dvds).where("dvds.id is not null").uniq.sort_by(&:name)
    @directors = Director.all.sort_by(&:lastname)

    @specials = Special.joins(:dvds).where("dvds.id is not null").uniq.sort_by(&:name)
    @items = apply_scopes(Dvd).includes(:justin).order("justins.day DESC").page(params[:page]).per(32)
    respond_to do |format|
      format.html {     render :template => 'shared/category_frontpage'}
      format.js { render :template => 'shared/ajax_category' }
    end
  end
  
  
  def show
    find_dvd
    set_meta_tags :title => @item.display_title
    render :template => 'shared/show'
  end


 
  
  def others
    @item = Dvd.find(params[:id])
    @offset = params[:offset]
    @til = @offset.to_i + 8
   # render :text => "offset is " + @offset.to_s + " and til is " + @til.to_s
    respond_to do |format|
      format.js 
    end
  end
  
 
  
  def find_dvd
    @item =  Dvd.friendly.find params[:id]
    if request.path != dvd_path(@item)
      return redirect_to @item, :status => :moved_permanently
    end
  end    
    
end
