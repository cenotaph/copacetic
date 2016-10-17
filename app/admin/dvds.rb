ActiveAdmin.register Dvd do
  scope :all, :default => true
  scope :in_stock do |dvds|
    dvds.where("instock is true")
  end
  scope :out_of_stock do |dvds|
    dvds.where("instock is false")
  end
  
  controller do
    autocomplete :director, :firstname, :display_value => :fullname, :extra_data => [:firstname, :lastname] 
    # autocomplete :creator, :firstname, :extra_data => [:lastname], :display_value => :fullname
  end
  
  form :partial => "form"

  
  index :as => :grid, :columns => 4 do |dvd|
    div :for => dvd do
      if dvd.image?
        a :href => admin_dvd_path(dvd) do
          image_tag(dvd.image.url(:frontgrid))
        end
      end
      div do
        a truncate(dvd.title), :href => edit_admin_dvd_path(dvd)
        div raw strip_links(dvd.authorship_short)
      end
      div do
        number_to_currency dvd.price
      end
      div do
        a 'see public view', :href => dvd_path(dvd)
      end
    end
  end
  

  show do
    h3 dvd.title_with_issue
    div do
      if dvd.image?
        image_tag dvd.image.url(:largest)
      end
    end
    attributes_table do
      row :title
      row :director_names
      row :publisher
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
        format.html { redirect_to @dvd }
      end
    end

    
    def update
      update! do |format|
        format.html { redirect_to @dvd }
      end
    end
  end
       
end
