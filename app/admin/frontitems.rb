ActiveAdmin.register Frontitem do
  controller do

    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
    
    def permitted_params
      params.permit(:frontitem => [:item_type, :image, :item_id, :position])
      # params.permit! # allow all parameters
    end


  end
  
  index :as => :grid do |fi|
    link_to image_tag(fi.item.image.url(:frontgrid)),  edit_admin_frontitem_path(fi)
 
  end
  
    menu :label => "Front grid"  
end
