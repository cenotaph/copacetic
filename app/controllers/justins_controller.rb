class JustinsController < InheritedResources::Base
  actions :show, :index, :latest
  
  def latest
    @item = Justin.published.order('day DESC').first
    @items = Kaminari.paginate_array(@item.items).page(params[:page]).per(32)       
    respond_to do |format|
      format.html { render :template => 'shared/belongs_to' }
      format.js { render :template => 'shared/ajax_belongs' }
    end
  end
  
  def show
    @item = Justin.friendly.find(params[:id])
    @items = Kaminari.paginate_array(@item.items).page(params[:page]).per(32)       
    respond_to do |format|
      format.html { render :template => 'shared/belongs_to' }
      format.js { render :template => 'shared/ajax_belongs' }
    end
  end
end