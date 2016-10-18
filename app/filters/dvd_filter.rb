class DvdFilter
  include Minidusen::Filter

  filter :text do |scope, phrases|
    columns = [:title, :description, :shortdesc]
    scope.where_like(columns => phrases)
  end

end