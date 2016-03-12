# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'json'

search_results_files = Dir.glob("db/json_search_results/*.json")

# assign each platform a unique id based on its index
search_results_files.each_with_index do |search_results_file, platform_index|
  
  ####################
  # Extract Platform #
  ####################

  # retrieve the platform that corresponds to the current file
  platform_name = search_results_file.split("/")[-1].split("_")[0..1].join("_")

  # assign a unique id to the platform (add 1 so platform.id == platform.platform_id)
  platform_id = platform_index

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
      :platform_id => platform_id
    )

    new_search.save!
 

    ####################
    # Save SearchGroup #
    ####################

    # Assign each search to a search group id. Each user will
    # be assigned a search group id as well, and they will
    # evaluate all of the search results for the searches in 
    # their designated search group id.
    search_group_id = 1

    new_search_group_record = SearchGroup.new(
      :search_group_id => search_group_id,
      :search_id => search_id,
      :platform_id => platform_id
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
