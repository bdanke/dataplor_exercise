require './dataplor'
require 'sinatra'

CSV_FILE="./nodes.csv"
BIRD_CSV_FILE="./birds.csv"

tree = AdjacencyData.new(CSV_FILE)
birds = BirdData.new(BIRD_CSV_FILE, tree)

get '/common_ancestor' do
  content_type :json
  tree.ancestor_data(params['a'].to_i, params['b'].to_i).to_json
end

get '/birds' do
  content_type :json
  birds.get_all_birds(JSON.parse(params["nodes"])).to_json
end