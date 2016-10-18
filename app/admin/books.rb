ActiveAdmin.register Book do
  
  scope :all, :default => true
  scope :in_stock do |books|
    books.where("instock is true")
  end
  scope :out_of_stock do |books|
    books.where("instock is false")
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
      params.permit(:book => [:title, :published_id, :hardcover, :pagecount, :listprice, :price, 
        :fiction, :dateadded, :instock, :description, :isbn, :ean, :numbersold, :image, :shortdesc, 
      :justin_id, :tinydesc, :weight, :slug])
      # params.permit! # allow all parameters
    end
    
    autocomplete :creator, :firstname, :display_value => :fullname, :extra_data => [:firstname, :lastname] 
    # autocomplete :creator, :firstname, :extra_data => [:lastname], :display_value => :fullname
  end
  
  form :partial => "form"

  
  index :as => :grid do |book|
    div do
      if book.image?
        a :href => admin_book_path(book) do
          image_tag(book.image.url(:frontgrid))
        end
      end
      div do
        a truncate(book.title), :href => edit_admin_book_path(book)
        div raw book.creator_names
      end
      div do
        number_to_currency book.price
      end
      div do
        a 'see public view', :href => book_path(book)
      end
    end
  end
  

  show do
    h3 book.title_with_issue
    div do
      if book.image?
        image_tag book.image.url(:largest)
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
        format.html { redirect_to admin_books_path }
      end
    end

    def update
      update! do |format|
        format.html { redirect_to admin_books_path }
      end
    end
  end
    
end
