ActiveAdmin.register Serial do
  controller do

    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
    
    def permitted_params
      params.permit(:serial => [:name, :description, :slug])
      # params.permit! # allow all parameters
    end


  end
    
end
