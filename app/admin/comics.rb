ActiveAdmin.register Comic do
  scope :all, :default => true
  scope :in_stock do |comics|
    comics.where("instock is true")
  end
  scope :out_of_stock do |comics|
    comics.where("instock is false")
  end
  
  collection_action :autocomplete_creator_firstname, :method => :get
  
  controller do

    def find_resource
      begin
        scoped_collection.where(slug: params[:id]).first!
      rescue ActiveRecord::RecordNotFound
        scoped_collection.find(params[:id])
      end
    end
    
    def permitted_params
      params.permit(:comic => [:title, :issue, :publisher_id, :listprice, :price, :dateadded, :instock, :description, :pagecount, 
        :dimensions, :numbersold, :image, :shortdesc, :tinydesc, :include_front_grid, :justin_id, :weight, :slug,
      :remove_image, serial_ids: [], special_ids: [], creators_attributes: [:firstname, :lastname, :_destroy, :id]])
      # params.permit! # allow all parameters
    end

    autocomplete :creator, :firstname, :display_value => :fullname, :extra_data => [:firstname, :lastname] #,   
  end

  
  form :partial => "form"

  
  index :as => :grid, :columns => 4 do |comic|

    div :for => comic do
      if comic.image?
        a :href => admin_comic_path(comic) do
          image_tag(comic.image.url(:frontgrid))
        end
      end
      div do
        a truncate(comic.title_with_issue), :href => edit_admin_comic_path(comic)
        div do
          raw comic.creator_names
        end
      end
      a number_to_currency(comic.price), :href => edit_admin_comic_path(comic)
      div do
        a 'see public view', :href => comic_path(comic),:target => :_blank
      end      
    end
  end
  

  show do
    h3 [comic.title, " #", comic.try(:issue)].join(' ')
    div do
      if comic.image?
        image_tag comic.image.url(:largest)
      end
    end
    attributes_table do
      row :publisher_name
      row :creator_names
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
        format.html { redirect_to admin_comics_path }
      end
    end
    def update
      update! do |format|
        format.html { redirect_to admin_comics_path }
      end
    end
  end
  
end
