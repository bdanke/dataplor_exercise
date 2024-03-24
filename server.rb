require './dataplor'
require 'sinatra'

CSV_FILE="test_nodes.csv"
BIRD_CSV_FILE="./birds.csv"

tree = AdjacencyData.new(CSV_FILE)
birds = BirdData.new(BIRD_CSV_FILE, tree)

get '/common_ancestor' do
  content_type :json
  tree.ancestor_data(params['a'], params['b']).to_json
end

get '/birds' do
  content_type :json
  birds.get_all_birds(JSON.parse(params["nodes"])).to_json
end