# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

####################
# Helper functions #
####################

def save_search_group_id(search_id, platform_id, search_group_id, search_phrase)
  """
  Read in the search id and platform id for a search, and the search
  group id to which we want to assign that search, and save this 
  record in the database
  """

  new_search_group_record = SearchGroup.new(
    :search_group_id => search_group_id,
    :search_id => search_id,
    :platform_id => platform_id,
    :search_phrase => search_phrase
  )

  new_search_group_record.save!

end


#################
# Main Function #
#################

search_results_files = Dir.glob("db/json_search_results/*.json")

# assign each platform a unique id based on its index
search_results_files.each_with_index do |search_results_file, platform_index|
  
  ####################
  # Extract Platform #
  ####################

  # retrieve the platform that corresponds to the current file
  platform_name = search_results_file.split("/")[-1].split("_")[0..1].join("_")

  # assign a unique id to the platform (add 1 so platform.id == platform.platform_id)
  platform_id = platform_index + 1

  # save the platform
  new_platform = Platform.new(
    :platform_name => platform_name,
    :platform_id => platform_id
  )

  new_platform.save!


  ####################
  # Extract Searches #
  ####################

  # read the file containing json 
  read_file = File.read(search_results_file)

  # parse the json from the file
  search_array = JSON.parse(read_file)

  # iterate over the array of queries. Each member of this
  # array is a dict with query and results keys
  search_array.each_with_index do |search_dict, search_index|
    search_phrase = search_dict["query"].split("+").join(" ")

    # give each search a unique id (add 1 so @search.id == @search.search_id)
    search_id = search_index + 1

    # save the search
    new_search = Search.new(
      :search_id => search_id,
      :search_phrase => search_phrase,
      :platform_id => platform_id,
      :search_phrase => search_phrase
    )

    new_search.save!
 

    ####################
    # Save SearchGroup #
    ####################

    """
    Assign each search to a search group id. Each user will
    be assigned a search group id as well, and they will
    evaluate all of the search results for the searches in 
    their designated search group id.
    """

    """
    We presently wish to assign each user 7 queries from the 
    platform group (which has 5 levels), 2 queries from 
    the discovery service platform group (which has 2 levels),
    and 1 query from the ebooks platform (which has 2 levels). 
    Manually select the queries associated with each platform
    """ 
     
    platform_names = ["proquest_platform", "ebsco_platform", "jstor_platform"]
    discovery_names = ["proquest_summon", "ebsco_discovery"]
    ebook_names = ["proquest_ebrary", "ebsco_ebooks"]

    # identify the number of queries to assign to each group
    n_platform_queries = 7
    n_discovery_queries = 2
    n_ebook_queries = 1

    """
    add questions 0..6 from the platform json to search group id 2
    also add questions 7..8 from the discovery json to search group id 2
    finally add question 9 from the ebook json to search group id 2

    only add a search to a search_group_id number 2
    if it has the appropriate platform
    and search number values
    """

    platform_searches = [
      "Brahms symphony no. 1",
      "phobia",
      "china electric vehicle",
      "customs law",
      "earth global warming",
      "Japanese fashion",
      "prisoners AND stress management"]
    
    discovery_searches = [
      "Mexico climate change",
      "coming of age in India"]
    
    ebook_searches = [
      "social injustice"]


    if platform_names.include? platform_name
      # subtract one from platform queries because of 0 based indexing
      #if (0..n_platform_queries-1).to_a.include? search_index
      if platform_searches.include? search_phrase
        save_search_group_id(search_id, platform_id, 2, search_phrase)
      end

    elsif discovery_names.include? platform_name
      # identify a range that begins with index position = n_platform_queries
      # and add a number of members to that range based on the number of
      # queries identified by n_discovery_queries
      #if (n_platform_queries..n_platform_queries+n_discovery_queries-1).to_a.include? search_index
      if discovery_searches.include? search_phrase
        save_search_group_id(search_id, platform_id, 2, search_phrase)
      end

    elsif ebook_names.include? platform_name
      #if (n_platform_queries+n_discovery_queries..n_platform_queries+n_discovery_queries).to_a.include? search_index 
      if ebook_searches.include? search_phrase  
        save_search_group_id(search_id, platform_id, 2, search_phrase)
      end
    end
   
    # add everything to search group 1
    search_group_id = 1

    new_search_group_record = SearchGroup.new(
      :search_group_id => search_group_id,
      :search_id => search_id,
      :platform_id => platform_id,
      :search_phrase => search_phrase
    )

    new_search_group_record.save!


    ###########################
    # Save the Search Results #
    ###########################

    # search results is an array of arrays:
    # [ 
    #   [search_result_0_componont_0, search_result_0_component_1...], 
    #   [search_result_1_component_0, search_result_1_component_1...]
    # ]
    search_results = search_dict["results"]

    # iterate over the search results in the record and
    # assign each search result a unique id based on its index
    # nb: only retrieve the first 10 search results
    search_results[0..9].each_with_index do |search_result, search_result_index|

      # save the search result 
      new_search_result = SearchResult.new(
        :search_id => search_id,
        :platform_id => platform_id,
        :search_result_index => search_result_index,
        :search_result_title => search_result["title"],
        :search_result_metadata => search_result["metadata"]
        )

      new_search_result.save!
    end
  end
end
