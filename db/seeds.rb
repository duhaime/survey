# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

exported_search_files = Dir.glob("db/exported_search_files/*.ris")

# assign each search a unique id based on its index
exported_search_files.each_with_index do |exported_search_file, search_index|
  
  ###############
  # Save Search #
  ###############

  # give this search a unique id
  search_id = search_index

  # extract the search phrase from the file name
  search_phrase = exported_search_file.split("/")[-1].gsub(/.ris/, '').split("_").join(" ")

  # save the search information
  new_search = Search.new(
    :search_id => search_id,
    :search_phrase => search_phrase
  )

  new_search.save!

  #####################
  # Save SearchResult #
  #####################

  # read the file with utf-8 encoding
  exported_search = File.open(exported_search_file, 'r:UTF-8',&:read)

  # split record into a list of search results
  search_results = exported_search.split("\r\n\r\n\r\n")[0..-2]

  # assign each search result a unique id based on its index
  search_results.each_with_index do |search_result, result_index|

    # initialize variables
    authors = []
    article_title = ''
    journal = ''
    row_content = ''
    publication_year = ''
    start_page = ''
    end_page = ''

    # each query result has one or more rows that detail
    # the result's author, title, etc. Iterate over those rows
    search_result_rows = search_result.split("\r\n")

    search_result_rows.each do |search_row|

      # identify the row label and content
      row_label = search_row[0..1]
      row_content = search_row[6..search_row.length]

      if row_label == "T1"
        article_title = row_content

      elsif row_label == "JF"
        journal = row_content

      elsif row_label == "PY"
        publication_year = row_content

      elsif row_label == "SP"
        start_page = row_content

      elsif row_label == "EP"
        end_page = row_content

      elsif row_label == "AU"
        authors.append(row_content)
      end
    end

  # join the author array into a string
  authors = authors.join(", ")

  # save the search result 
  new_search_result = SearchResult.new(
    :search_id => search_id,
    :result_title => article_title,
    :result_journal => journal,
    :result_publication_year => publication_year,
    :result_start_page => start_page,
    :result_end_page => end_page,
    :result_authors => authors
    )

  new_search_result.save!

  end
end
