class DirectorFilter
  include Minidusen::Filter

  filter :text do |scope, phrases|
    columns = [:firstname, :description, :lastname]
    scope.where_like(columns => phrases)
  end

end