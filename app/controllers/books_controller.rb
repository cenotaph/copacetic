class BooksController < ApplicationController
  has_scope :by_special
  has_scope :by_publisher
  has_scope :by_creator

  autocomplete :creator, :firstname, extra_data: [:lastname], display_value: :fullname, scopes: [:book_creators]
  
  def add_comment
    @comment = Book.find(params[:id]).comments.create(params[:comment])
    @comment.date = Time.now
   @comment.user_id = current_user.id

    if @comment.save
      flash[:notice] = 'Your comment is awaiting approval.  Thanks!'
      redirect_to :action=>'show', :id => params[:id]
    end
  end
  
  
  def add_creator_form
     render :partial => 'layouts/creatorinput', :locals => { :count => params[:count], :itemtype => 'book' } 
  end
  
  def allcreators 
      @creators = Creator.find_by_sql("SELECT DISTINCT  IF(c.firstname IS NULL, c.lastname, CONCAT(c.firstname, ' ', c.lastname)) AS fullname, c.id FROM creators c, creators_books cb WHERE cb.creator_id = c.id ORDER BY c.lastname")
  end
  
  def auto_complete_for_book_creator_names
        search = params[:book][:creator_names]
        @creatorsearch = Creator.find(:all, :conditions => ["(lower(lastname) LIKE lower(?)) OR (lower(firstname) LIKE lower(?))", "%#{search}%", "%#{search}%"], :order => 'lastname') unless search.blank?
        logger.warn("creatorsearch is " + @creatorsearch.inspect)
        render :partial => "creatorsearch" 
    end
  
    
  def auto_complete_for_book_publisher_name
       @publishersearch = Publisher.find(:all, :conditions => ["lower(name) like lower(?)", "%#{params[:book][:publisher_name]}%"])
       render :partial => "publishersearch"
  end

  def index
    set_meta_tags :title => 'Books'
    @featured = Special.find_by(name: 'FEATURED ITEM').books.order(updated_at: :desc)
    @publishers = Publisher.joins(:books).where('books.id is not null').uniq.sort_by(&:name)
    @creators = Book.find_by_sql("SELECT cr.id, IF(cr.firstname IS NULL, cr.lastname, CONCAT(cr.firstname, ' ', cr.lastname)) AS fullname , count(cb.book_id) FROM creators_books cb, creators cr WHERE cr.id = cb.creator_id GROUP BY lastname HAVING (count(cb.book_id) >= 1)  ORDER BY cr.lastname")
   # @serials = Book.find_by_sql("SELECT DISTINCT  s.id, s.name FROM serials_books sb, serials s WHERE sb.serial_id = s.id ORDER BY name")
    # @specials = Book.find_by_sql("SELECT DISTINCT s.id, s.name FROM specials_books sb, specials s WHERE sb.special_id = s.id AND name != 'FEATURED ITEM' AND name != 'SHOW ON FRONT PAGE' ORDER BY name")
    @specials = Special.joins(:books).where('books.id is not null').uniq.sort_by(&:name)
    @items = apply_scopes(Book).includes(:justin).order("justins.day DESC").page(params[:page]).per(32)
    respond_to do |format|
      format.html {     render :template => 'shared/category_frontpage' }
      format.js { render :template => 'shared/ajax_category' }
    end
  end
  

  
  def show
    @item = Book.friendly.find(params[:id])
    if request.path != book_path(@item)
      return redirect_to @item, :status => :moved_permanently
    end
    @head = Hash.new
    set_meta_tags :open_graph => {
        :title =>  @item.combinedname,
        :type  => :book},
        :title => @item.combinedname, :description => @item.description
    render :template => 'shared/show' 
  end




  def delfront
      Frontitem.find(:first, :conditions => ['original_id = ? AND category = 2', params[:id]]).destroy
      redirect_to :action => 'edit', :id => params[:id]
  end
  


  def others
    @item = Book.find(params[:id])
    @offset = params[:offset]
    @til = @offset.to_i + 6
   # render :text => "offset is " + @offset.to_s + " and til is " + @til.to_s
    render :layout => false, :template => "layouts/_others"
  end
  


  protected
  
  def find_book
    Book.find params[:id]
    if request.path != book_path(@book)
      return redirect_to @book, :status => :moved_permanently
    end
  end    

end
