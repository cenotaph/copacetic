class DirectorsController < InheritedResources::Base
  actions :show, :index

  def show
    @item = Director.friendly.find(params[:id])
    @items = Kaminari.paginate_array(@item.items).page(params[:page]).per(32)
    set_meta_tags :title => @item.fullname, :description => ( @item.description.blank? ? ''  : @item.description)  
    respond_to do |format|
      format.html { render :template => 'shared/belongs_to' }
      format.js { render :template => 'shared/ajax_belongs' }
    end
  end
end