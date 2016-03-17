RailsSurveyApp::Application.routes.draw do
  resources :researcher_rankings
  resources :searches
  resources :researchers

  # add method to show static instruciton page
  get "instruction/show"

  # add show method of graph controller
  get "graph/show"

  # allow the graph method of the graph controller to pass json
  get "graph/data", :defaults => { :format => 'json' }

  # add show method of survey_completed to thank 
  # researchers for their time
  get "survey_completed/show"
  
  # set methods to create and show researcher
  get "researcher_rankings/create"
  get "researcher_rankings/new"
  get "researcher_rankings/show"

  # set the application home page
  root 'home#show'

  # add methods that show particular researchers or searches
  get 'researcher/:id' => 'researchers#show'
  get 'search/:id' => 'searches#show'
end