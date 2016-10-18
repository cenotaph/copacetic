class PublisherFilter
  include Minidusen::Filter

  filter :text do |scope, phrases|
    columns = [:name, :description, :tinydesc]
    scope.where_like(columns => phrases)
  end

end