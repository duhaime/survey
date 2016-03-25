class GraphController < ApplicationController
  def show
    @search_phrase_array = ResearcherRanking.uniq.pluck(:search_phrase)
  end


  def data
    respond_to do |format|
      format.json {
        render :json => retrieve_json()
      }
    end
  end


  def retrieve_json()
    """
    For each search phrase, find all platforms for which that search phrase
    is relevant. Then, for each platform, find the percent of researchers who
    deem that platform's top 10 hits for that search phrase relevant. 

    the json served will be of form:
      json = {

        // there is one json key for all search results
        'search_results': {

          // each search is a key in the search_results dict
          'material world': {
            
            // each key is a result index
            1: [
                {'platform_id': 1,
                  'percent_relevant: .8
                },
                {}, ...
                {}
              ],
            2: ...
          },
            
          'material girl': { 1:{}, 2:{}, ...10:{} }

      // there is another json key for the platform id and name array
      'platform_id_and_name_array': 

        [ [platform_id, platform_name], [] ]

      }
    """
    # create the json to be served to the client at /graph/data.json
    search_relevancy_json = {
      "platform_id_and_name_array" => [],
      "search_results" => {}}

    #####################################
    # Update platform id and name array #
    #####################################

    for platform_record in Platform.all
      search_relevancy_json["platform_id_and_name_array"] << {
        "platform_id" => platform_record.platform_id, 
        "platform_name" => platform_record.platform_name
      }
    end

    ##############################
    # Update search results json #
    ##############################

    # iterate over all search phrases for which we have evaluations
    ResearcherRanking.uniq.pluck(:search_phrase).each do |search_phrase|

      # add the current search phrase as a key in the json to be served
      search_relevancy_json["search_results"][search_phrase] = []

      researcher_rankings_for_current_search = ResearcherRanking.where(search_phrase: search_phrase)

      # find all platforms for which we have responses to this search phrase
      researcher_rankings_for_current_search.uniq.pluck(:platform_id).each do |platform_id|

        platform_json = {}

        # retrieve the researcher rankings for the given search_phrase and platform_id combination
        relevant_rankings = researcher_rankings_for_current_search.where(platform_id: platform_id)

        # populate a list of all result_* keys in the given researcher ranking objects
        result_keys = []

        # loop over all attributes of the first member of relevant_rankings
        relevant_rankings.first.attributes.each do |attribute|

          # a is an array of form ["key", value]
          # if "result_" is in the key, add the key to result_keys
          if attribute[0].to_s.include? 'result_'
            unless attribute[1].nil?
              result_keys << attribute[0]
            end
          end
        end

        """
        given the keys corresponding to result options for the current 
        search, compute the number of true and false responses for 
        each search response for the search
        """

        result_keys.each do |result_key|

          n_true = relevant_rankings.where(result_key.parameterize.underscore.to_sym => true).length
          n_false = relevant_rankings.where(result_key.parameterize.underscore.to_sym => false).length
          percent_true = n_true.fdiv(n_true + n_false)

          # the result_key object is a string of form: 'result_1'
          # create an object that retains only the integer portion of this
          # string
          result_number = result_key.split("_")[1].to_i

          # add a hash containing platform_id, result_index, and a
          # percent relevant score
          search_relevancy_json["search_results"][search_phrase] << {
            "result_index" => result_number,
            "platform_id" => platform_id, 
            "percent_relevant" => percent_true
          }

        end
      end
    end
    return search_relevancy_json
  end
end
