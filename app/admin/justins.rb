ActiveAdmin.register Justin , :as => "Updates" do
  menu :label => "Updates"  
  controller do

    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
    
    def permitted_params
      params.permit(:justin => [:day, :name, :description, :published, :slug])
      # params.permit! # allow all parameters
    end


  end
  
end
