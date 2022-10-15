class SearchController < ApplicationController
  def search
    @results = model_klass.search(params[:search_data])

    render :result
  end

  private

  def model_klass
    return ThinkingSphinx if params[:search_type] == 'all'

    params[:search_type].camelize.constantize
  end
end
