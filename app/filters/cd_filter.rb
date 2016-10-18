class CdFilter
  include Minidusen::Filter

  filter :text do |scope, phrases|
    columns = [:title, :artist, :description, :shortdesc]
    scope.where_like(columns => phrases)
  end

end