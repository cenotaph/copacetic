class CreatorFilter
  include Minidusen::Filter

  filter :text do |scope, phrases|
    columns = [:firstname, :lastname, :description]
    scope.where_like(columns => phrases)
  end

end