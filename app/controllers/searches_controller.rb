class SearchesController < ApplicationController
  def show
    if params[:query]
      searcher = Searcher.new

      search_options = search_params.dup
      search_options.delete :query

      begin
        @candidates, @total_results, @facets = searcher.search(params[:query], search_options)

        # Put into service object
        current_user.search_performeds.create({
          query: search_params[:query],
          filters: search_options.except(:query, :page).select {|key, value| value.present? && (value.is_a?(Array) ? value.select {|array_value| array_value.present? }.any? : true) },
          page: search_params[:page],
          per_page: Searcher::RESULTS_PER_PAGE
        })

        @searched = true
      rescue Searchkick::InvalidQueryError
        flash.now[:error] = "Could not complete search due to invalid search syntax. Please refer to #{view_context.link_to "this guide", "https://www.elastic.co/guide/en/elasticsearch/reference/7.16/query-dsl-query-string-query.html#query-string-syntax"} for correct search syntax.".html_safe
      end
    else
      @searched = false
    end
  end

  private

  def search_params
    params.permit(:query,
                  :gender_diverse,
                  :ethnically_diverse,
                  :veteran,
                  :open_to_opportunities,
                  :has_disability,
                  :student,
                  :us_only,
                  :keywords,
                  :page,
                  locations: [:location, :radius],
                  companies: [],
                  industries: [],
                  titles: [],
                  years_of_experiences: [],
                  company_headcounts: [])
  end
end