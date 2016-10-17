ActiveAdmin.register Article do
  
  action_item :only => :show do
    _article = assigns['article']
    link_to('View on public site', _article, :target => :_blank)
  end
    
  scope :all, :default => true
  scope :published do |articles|
    articles.where("published is true")
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
      params.permit(:article => [:title, :content, :blurb, :slug, :published, :sortorder, :in_universe, :quotidian])
      # params.permit! # allow all parameters
    end
    
    
    autocomplete :creator, :firstname, :display_value => :fullname, :extra_data => [:firstname, :lastname] #,   
  end

  
  form :partial => "form"

  index :as => :blog do 
    title do |article|
      link_to article.title, edit_admin_article_path(article)
    end
    body do |article|
      truncate(raw(sanitize(article.content, :tags => [])), :length => 250)
    end

  end
  

  show do |article|
 
    h3 article.title
    div do
      raw article.content
    end
  end
    
end
