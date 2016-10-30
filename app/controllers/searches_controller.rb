class SearchesController < ApplicationController
  
  def create
    @items = ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:query]), :classes => [Comic, Book, Dvd, Cd], field_weights: {
        title: 10,
        description: 1 }, page: params[:page], per: 20
    # creators_and_directors = ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:query]), :classes => [Director, Creator],  field_weights: {
    #     lastname: 10,
    #     firstname: 8, description: 5 }
    # unless creators_and_directors.empty?
    #   other_items = creators_and_directors.map(&:items).uniq
    # end

   # @items = Kaminari.paginate_array(@items).page(params[:page]).per(32)
    render 'shared/search_results'
  end
  
  def index
    @items = ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:query]), :classes => [Comic, Book, Dvd, Cd], field_weights: {
        title: 10,
        description: 1 }, page: params[:page], per: 20
    # creators_and_directors = ThinkingSphinx.search ThinkingSphinx::Query.escape(params[:query]), :classes => [Director, Creator],  field_weights: {
    #     lastname: 10,
    #     firstname: 8, description: 5 }
    # unless creators_and_directors.empty?
    #   other_items = creators_and_directors.map(&:items).uniq
    # end

    
   # @items = Kaminari.paginate_array(@items).page(params[:page]).per(32)

    if !request.xhr?
      render 'shared/search_results'
    end
  end
  
end