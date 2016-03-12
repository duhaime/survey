class GraphController < ApplicationController
  def show
    @searches = ResearcherRanking.uniq.pluck(:search_id)
    @search_labels = retrieve_search_labels(@searches)
  end

  def data
    respond_to do |format|
      format.json {
        render :json => retrieve_json()
      }
    end
  end

  def retrieve_json()

    # Determine the percent of researchers who deem each response
    # to each query 'relevant', and return json that captures this
    # data
    search_relevancy_json = {}
    
    # populate an array of all unique search ids, and pass each into k
    ResearcherRanking.uniq.pluck(:search_id).each do |search_id|

      # retrieve the search phrase for this search_id
      search_phrase = Search.find_by(search_id: search_id).search_phrase

      # add the current search id as a key in the json
      search_relevancy_json[search_id] = {}

      # retrieve an array of all rankings for the current value of search_id
      key_rankings = ResearcherRanking.where(search_id: search_id)

      # given those rankings, find all unique result values
      result_keys = []

      # loop over all attributes of the first member of result_keys
      key_rankings.first.attributes.each do |attribute|

        # a is an array of form ["key", value]
        # if "result_" is in the key, add the key to result_keys
        if attribute[0].to_s.include? 'result_'
          unless attribute[1].nil?
            result_keys << attribute[0]
          end
        end
      end

      # given the non-nil keys for the current search, compute the number
      # of true and false responses for each search response for the search
      relevant_searches = ResearcherRanking.where(search_id: search_id)
      result_keys.each do |result_key|

        n_true = relevant_searches.where(result_key.parameterize.underscore.to_sym => true).length
        n_false = relevant_searches.where(result_key.parameterize.underscore.to_sym => false).length
        percent_true = n_true.fdiv(n_true + n_false)

        # add the result_key and percent_true to the appropriate search_id
        # value in the json
        search_relevancy_json[search_id][result_key] = percent_true
      end
    end
    return search_relevancy_json
  end

  def retrieve_search_labels(search_ids)
    # read in an array of search ids and return search labels for each
    search_labels = []
    search_ids.each do |search_id|
      search_labels << Search.find_by(search_id: search_id).search_phrase
    end
    return search_labels
  end

end
