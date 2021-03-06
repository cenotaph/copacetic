class CdsController < ApplicationController
  has_scope :by_special
  has_scope :by_publisher
  has_scope :by_serial
  has_scope :by_creator
  has_scope :by_artist
  autocomplete :cd, :artist
  
  def auto_complete_for_cd_label_name
       @publishersearch = Label.find(:all, :conditions => ["lower(name) like lower(?)", "%#{params[:cd][:label_name]}%"], :order => 'name')
       render :partial => "publishersearch"
  end

  def by_artist
    @items = Cd.where(:artist => params[:id].gsub(/%20/, ' ')).page(params[:page]).per(32)
    set_meta_tags :title => @items.first.artist 
    respond_to do |format|
      format.html {     render :template => 'shared/belongs_to' }
      format.js  { render :template => 'shared/ajax_category' }
    end
  end
  
  def index
    set_meta_tags :title => 'Music'
    @featured = Special.find_by(name: 'FEATURED ITEM').cds.order(updated_at: :desc)
    @labels = Label.includes(:cds).sort_by(&:name).uniq

    @specials = Special.joins(:cds).where("cds.id is not null").uniq.sort_by(&:name)
    @items = apply_scopes(Cd).includes(:justin).order("justins.day DESC").page(params[:page]).per(32)
    respond_to do |format|
      format.html {     render :template => 'shared/category_frontpage' }
      format.js  { render :template => 'shared/ajax_category' }
    end
  end

   def others
     @item = Cd.friendly.find(params[:id])
     @offset = params[:offset]
     @til = @offset.to_i + 7
    respond_to do |format|
      format.js 
    end
   end
   
  def show
    @item = Cd.friendly.find(params[:id])
    set_meta_tags :title => @item.display_title    
    render :template => 'shared/show'
  end


end
