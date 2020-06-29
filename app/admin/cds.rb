ActiveAdmin.register Cd do
   scope :all, :default => true
  scope :in_stock do |cds|
    cds.where("instock is true")
  end
  scope :out_of_stock do |cds|
    cds.where("instock is false")
  end
  
  controller do
    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
    
    def permitted_params
      params.permit(:cd => [:title, :artist, :label_id, :numofdiscs, :genre_id, :listprice, :price, :dateadded, :instock, :description, :include_front_grid,
        :numbersold, :justin_id, :shortdesc, :tinydesc, :image, :catno, :keywords, :weight, :slug,  :remove_image, special_ids: []])
      # params.permit! # allow all parameters
    end
    
    autocomplete :creator, :firstname, :display_value => :fullname, :extra_data => [:firstname, :lastname] 
    # autocomplete :creator, :firstname, :extra_data => [:lastname], :display_value => :fullname
  end
  
  form :partial => "form"

  
  index :as => :grid do |cd|
    div do
      if cd.image?
        a :href => admin_cd_path(cd) do
          image_tag(cd.image.url(:frontgrid))
        end
      end
      div do
        a truncate(cd.title), :href => edit_admin_cd_path(cd)
        div raw cd.artist
      end
      div do
        number_to_currency cd.price
      end
      div do
        a 'see public view', :href => cd_path(cd)
      end      
    end
  end
  

  show do
    h3 cd.title_with_issue
    div do
      if cd.image?
        image_tag cd.image.url(:largest)
      end
    end
    attributes_table do
      row :artist
      row :title
      row :label
      row :listprice
      row :price
      row :dateadded
      row :instock
      row :weight
    end
  end 

  controller do
    def create 
      create! do |format|
        format.html { redirect_to @cd }
      end
    end

    def update
      update! do |format|
        format.html { redirect_to @cd }
      end
    end
  end  
end
