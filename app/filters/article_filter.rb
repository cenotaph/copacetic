class ArticleFilter
  include Minidusen::Filter

  filter :text do |scope, phrases|
    columns = [:title, :content, :blurb]
    scope.where_like(columns => phrases)
  end

end