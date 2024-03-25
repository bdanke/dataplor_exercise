require 'csv'

class AdjacencyData
  attr_reader :parent_to_children

  def initialize(csv_file)
    @child_to_parent = {}
    @parent_to_children = {}
    CSV.foreach(csv_file, headers: true) do |row|
      child = row[0].to_i
      parent = row[1].to_i unless row[1].nil?

      @child_to_parent[child] = parent

      if @parent_to_children[parent]
        @parent_to_children[parent] << child
      else
        @parent_to_children[parent] = [child]
      end
    end
  end

  def path_to_root(node_id)
    return [node_id] if @child_to_parent[node_id].nil?
    [node_id] + path_to_root(@child_to_parent[node_id])
  end

  def ancestor_data(node_id_1, node_id_2)
    path_1 = path_to_root(node_id_1)
    return { root_id: path_1.last, lowest_common_ancestor: node_id_1, depth: path_1.length } if node_id_1 == node_id_2

    path_2 = path_to_root(node_id_2)
    shared_path = (path_1 & path_2)
    return { root_id: nil, lowest_common_ancestor: nil, depth: nil } if shared_path.empty?

    { root_id: path_1.last, lowest_common_ancestor: shared_path.first, depth: shared_path.length }
  end
end

class BirdData
  def initialize(csv_file, adjacency_data)
    @tree = adjacency_data
    @birds = {}
    @visited_nodes = []

    CSV.foreach(csv_file) do |row|
      node = row[0].to_i
      birds = row[1].to_i
      if @birds[node]
        @birds[node] << birds
      else
        @birds[node] = [birds]
      end
    end
  end

  def parent_to_children
    @tree.parent_to_children
  end

  def get_all_birds(nodes)
    unique_nodes = nodes.uniq
    birds = unique_nodes.inject([]) do |acc, node|
      acc + get_birds(node)
    end
    @visited_nodes = []
    birds
  end

  def get_birds(node)
    return [] if @visited_nodes.include?(node)
    @visited_nodes << node

    return @birds[node] || [] if parent_to_children[node].nil?
    (@birds[node] || []) + parent_to_children[node].inject([]) { |acc, child| acc + get_birds(child) }
  end
end