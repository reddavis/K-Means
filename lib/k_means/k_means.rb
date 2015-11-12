require 'ext/object'
require 'pry'

class KMeans

  attr_reader :centroids, :nodes, :max_iterations, :max_tries

  def initialize(data, options={})

    @max_tries = options[:max_tries] || 10

    @best_DBI = Float::INFINITY
    @best_centroids = nil
    @distance_measure = options[:distance_measure] || :euclidean_distance
    @nodes = Node.create_nodes(data, @distance_measure)
    @max_iterations = options[:max_iterations] || 100
    @verbose = options[:verbose]

    @centroid_count = options[:centroids] || 4

    raise "Too many centroids(#{@centroid_count}) for #{@nodes.size} nodes" if @centroid_count > @nodes.size

    @max_tries.times do |n|
      reset_nodes!
      @centroids = options[:custom_centroids] ||
        Centroid.create_centroids(@centroid_count, @nodes)

      perform_cluster_process
      dbi = davies_bouldin_index
      if dbi < @best_DBI
        p "#{n} #{dbi.round(2)} vs #{@best_DBI.round(2)}" if options[:debug]
        @best_DBI = dbi
        @best_centroids = @centroids
      end
    end


    if @best_centroids != nil
      # can not fit nodes to all clusters
      @centroids = @best_centroids
    end



    update_nodes(true) # force update
    assign_nodes_to_centriods
    place_nodes_into_pockets

    #binding.pry if options[:debug]

  end

  def inspect
    @centroid_pockets.inspect
  end

  def view
    @centroid_pockets
  end

  # Davies–Bouldin index: http://en.wikipedia.org/wiki/Cluster_analysis#Evaluation_of_clustering
  def davies_bouldin_index(centroids = @centroids)
    c_sz = centroids.size
    db_index = 0
    (0..(c_sz - 1)).each do |i|
      max_db_index = -1.0/0
      (0..(c_sz - 1)).each do |j|
        if i != j
          centroid_dist = centroids[i].position.send(@distance_measure, centroids[j].position)
          sum_mean_nodes = centroids[i].mean_node_distance + centroids[j].mean_node_distance
          max_db_index = [max_db_index, sum_mean_nodes / centroid_dist].max
        end
      end
      db_index += max_db_index
    end
    return db_index/c_sz
  end

  def reset_nodes!
    if @nodes
      @nodes.each{|n| n.reset!}
    end
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
    assign_nodes_to_centriods
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

  def assign_nodes_to_centriods
    @nodes.each_with_index do |node, node_index|
      #Store closest nodes in the centroid object
      node.closest_centroid.nodes << node
    end
  end

  def update_nodes(force = false)
    sum = 0
    @nodes.each do |node|
      sum += node.update_closest_centroid(@centroids, force)
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
