class ComicsController < InheritedResources::Base
  has_scope :by_special
  has_scope :by_publisher
  has_scope :by_serial
  has_scope :by_creator

  
  
  def auto_complete_for_comic_creator_names
        search = params[:comic][:creator_names]
        @creatorsearch = Creator.find(:all, :conditions => ["(lower(lastname) LIKE lower(?)) OR (lower(firstname) LIKE lower(?))", "%#{search}%", "%#{search}%"], :order => 'lastname') unless search.blank?
        logger.warn("creatorsearch is " + @creatorsearch.inspect)
        render :partial => "creatorsearch" 
      end

 def auto_complete_for_comic_publisher_name
    @publishersearch = Publisher.find(:all, :conditions => ["lower(name) like lower(?)", "%#{params[:comic][:publisher_name]}%"])
    render :partial => "publishersearch"
 end
      
  def auto_complete_for_comic_serial_name
     @publishersearch = Serial.find(:all, :conditions => ["lower(name) like lower(?)", "%#{params[:comic][:serial_name]}%"])
     render :partial => "publishersearch"
  end
  
         
  def index
    set_meta_tags :title => 'Comics'
      
  #  @featured = Comic.find(:all, :include => 'specials', :conditions => [ 'special_id = 7'])
    @featured = Special.find_by(name: 'FEATURED ITEM').comics.order(updated_at: :desc)
    @publishers = Publisher.joins(:comics).where("comics.id is not null")
    #   @creators = Comic.find_by_sql("SELECT cr.id, IF(cr.firstname IS NULL, cr.lastname, CONCAT(cr.firstname, ' ', cr.lastname)) AS fullname , count(cc.comic_id) FROM creators_comics cc, creators cr WHERE cr.id = cc.creator_id GROUP BY firstname, lastname HAVING (count(cc.comic_id) >= 3)  ORDER BY cr.lastname")
    @serials = Comic.find_by_sql("SELECT DISTINCT  s.id, s.name FROM serials_comics sc, serials s WHERE sc.serial_id = s.id ORDER BY name")
    @specials = Special.joins(:comics).where("comics.id is not null")
    @items = apply_scopes(Comic).includes(:justin).order("justins.day DESC").page(params[:page]).per(32)
    respond_to do |format|
      format.html { render :template => 'shared/category_frontpage' }
      format.js { render :template => 'shared/ajax_category' }
    end
  end

  def open_desc
    @comic = Comic.find(params[:id])
    render :action => 'desc', :layout => false
  end
  
  def others
    @item = Comic.find(params[:id])
    @offset = params[:offset]
    @til = @offset.to_i + 6
   # render :text => "offset is " + @offset.to_s + " and til is " + @til.to_s
    respond_to do |format|
      format.js 
    end
  end
    
  
        
  def show
    @item = Comic.friendly.find(params[:id])
    if request.path != comic_path(@item)
      return redirect_to @item, :status => :moved_permanently
    end
    @head = Hash.new
    set_meta_tags :open_graph => {
        :title =>  @item.combinedname,
        :type  => :comic},
        :title => @item.combinedname, 
        :description => (@item.shortdesc.blank? ? @item.description : @item.shortdesc)
    render :template => 'shared/show' 
  end
  
  def delfront
      Frontitem.find(:first, :conditions => ['original_id = ? AND category = 1', params[:id]]).destroy
      redirect_to :action => 'edit', :id => params[:id]
  end
      

  def find_comic
    Comic.find params[:id]
    if request.path != comic_path(@comic)
      return redirect_to @comic, :status => :moved_permanently
    end
  end    
    

end
