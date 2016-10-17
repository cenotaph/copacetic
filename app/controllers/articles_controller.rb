class ArticlesController < InheritedResources::Base
  actions :show, :index
  
  def index
    @articles = Article.copacetica
    super
  end
  
  def show
    @article = Article.friendly.find(params[:id])
    if request.path != article_path(@article)
      return redirect_to @article, :status => :moved_permanently
    end
  end
  
end