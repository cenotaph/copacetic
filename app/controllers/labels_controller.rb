class LabelsController < InheritedResources::Base
  actions :show, :index
  
  def show
    @item = Label.find(params[:id])
    if request.path != label_path(@item)
      return redirect_to @item, :status => :moved_permanently
    end
    @items = Kaminari.paginate_array(@item.items).page(params[:page]).per(32)
    set_meta_tags :title => @item.name, :description => ( @item.description.blank? ? false  : @item.description)    
    respond_to do |format|
      format.html { render :template => 'shared/belongs_to' }
      format.js { render :template => 'shared/ajax_belongs' }
    end
  end
end
