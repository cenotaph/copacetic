class SerialFilter
  include Minidusen::Filter

  filter :text do |scope, phrases|
    columns = [:name, :description]
    scope.where_like(columns => phrases)
  end

end