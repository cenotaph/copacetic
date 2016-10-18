class SearchesController < ApplicationController
  
  def create
    @items = []
    @items << ComicFilter.new.filter(Comic.instock, params[:query])
    @items << BookFilter.new.filter(Book.instock, params[:query])
    @items << DvdFilter.new.filter(Dvd.instock, params[:query])
    @items << CreatorFilter.new.filter(Creator, params[:query]).try(:items)
    @items << CdFilter.new.filter(Cd.instock, params[:query])
    @items << DirectorFilter.new.filter(Director, params[:query]).try(:dvds)
    
    @items = Kaminari.paginate_array(@items.flatten.compact).page(params[:page]).per(32)
    render 'shared/search_results'
  end
  
  def index
    @items = []
    @items << ComicFilter.new.filter(Comic.instock, params[:query])
    @items << BookFilter.new.filter(Book.instock, params[:query])
    @items << DvdFilter.new.filter(Dvd.instock, params[:query])
    @items << CreatorFilter.new.filter(Creator, params[:query]).try(:items)
    @items << CdFilter.new.filter(Cd.instock, params[:query])
    @items << DirectorFilter.new.filter(Director, params[:query]).try(:dvds)
    
    @items = Kaminari.paginate_array(@items.flatten.compact).page(params[:page]).per(32)
    if !request.xhr?
      render 'shared/search_results'
    end
  end
  
end