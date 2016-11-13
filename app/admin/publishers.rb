ActiveAdmin.register Publisher do
  controller do

    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
    
    def permitted_params
      params.permit(:publisher => [:name, :description, :tinydesc, :keywords, :slug])
      # params.permit! # allow all parameters
    end

    autocomplete :creator, :firstname, :display_value => :fullname, :extra_data => [:firstname, :lastname] #,   
  end
    
end
