ActiveAdmin.register Logo do
  controller do

    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
    
    def permitted_params
      params.permit(:logo => [:filename])
      # params.permit! # allow all parameters
    end


  end
  
  index :as => :grid, :columns => 4 do |logo|
    div :for => logo do
      div link_to image_tag(logo.filename.url(:standard)), edit_admin_logo_path(logo)
      div "uploaded #{logo.created_at}"
    end
    
  end
    
end
