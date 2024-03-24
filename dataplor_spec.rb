require 'rspec'
require './dataplor'

CSV_FILE="instructions_nodes.csv"
BIRD_NODES_CSV_FILE="./test_nodes.csv"
BIRD_CSV_FILE="./birds.csv"

RSpec.describe "Coding Exercise" do
  context "#ancestor_data" do
    let(:tree) { AdjacencyData.new(CSV_FILE) }

    it "returns the correct data" do
      expect(tree.ancestor_data(5497637, 2820230)).to eq({root_id: 130, lowest_common_ancestor: 125, depth: 2})
      expect(tree.ancestor_data(5497637, 130)).to eq({root_id: 130, lowest_common_ancestor: 130, depth: 1})
      expect(tree.ancestor_data(5497637, 4430546)).to eq({root_id: 130, lowest_common_ancestor: 4430546, depth: 3})
      expect(tree.ancestor_data(9, 4430546)).to eq({root_id: nil, lowest_common_ancestor: nil, depth: nil})
      expect(tree.ancestor_data(4430546, 4430546)).to eq({root_id: 130, lowest_common_ancestor: 4430546, depth: 3})
    end
  end

  context "#get_all_birds" do
    let(:tree) { AdjacencyData.new(BIRD_NODES_CSV_FILE) }
    let(:birds) { BirdData.new(BIRD_CSV_FILE, tree) }

    it "returns the correct data" do
      expect(birds.get_all_birds([6])).to match_array [5,6]
      expect(birds.get_all_birds([4])).to match_array [4,9,10]
      expect(birds.get_all_birds([4,6])).to match_array [4,9,10,5,6]
      expect(birds.get_all_birds([2,5])).to match_array [1,8,3,4,9,10,5,6]
    end
  end
end