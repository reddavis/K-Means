require 'ext/object'

class KMeans

  attr_reader :centroids, :nodes, :max_iterations

  def initialize(data, options={})
    distance_measure = options[:distance_measure] || :euclidean_distance
    @nodes = Node.create_nodes(data, distance_measure)
    @centroids = options[:custom_centroids] ||
      Centroid.create_centroids(options[:centroids] || 4, @nodes)
    @verbose = options[:verbose]
    @max_iterations = options[:max_iterations] || 100

    perform_cluster_process
  end

  def inspect
    @centroid_pockets.inspect
  end

  def view
    @centroid_pockets
  end

  private

  def perform_cluster_process
    iterations, updates = 0, 1
    while updates > 0 && iterations < max_iterations
      iterations += 1
      verbose_message("Iteration #{iterations}")
      updates = 0
      updates += update_nodes
      reposition_centroids
    end
    place_nodes_into_pockets
  end

  # This creates an array of arrays
  # Each internal array represents a centroid
  # and each in the array represents the nodes index
  def place_nodes_into_pockets
    centroid_pockets = Array.new(@centroids.size) {[]}
    @centroids.each_with_index do |centroid, centroid_index|
      @nodes.each_with_index do |node, node_index|
        if node.closest_centroid == centroid
          centroid_pockets[centroid_index] << node_index
        end
      end
    end
    @centroid_pockets = centroid_pockets
  end

  def update_nodes
    sum = 0
    @nodes.each do |node|
      sum += node.update_closest_centroid(@centroids)
    end
    sum
  end

  def reposition_centroids
    centroid_positions = @centroids.map(&:position)
    @centroids.each do |centroid|
      nodes = []
      @nodes.each {|n| nodes << n if n.closest_centroid == centroid}
      centroid.reposition(nodes, centroid_positions)
    end
  end

  def verbose_message(message)
    puts message if @verbose
  end

end
