class Centroid

  class << self

    # initial centroid positions are randomly chosen from within
    # a bounding box that encloses all the nodes
    def create_centroids(amount, nodes)
      ranges = create_ranges(nodes, nodes[0].position.size)
      (1..amount).map do
        position = ranges.inject([]) do |array, range|
          array << rand_between(range[0], range[1])
        end
        new(position)
      end
    end

    private

    # find centroi  d ranges as a bounding box for all nodes
    def create_ranges(nodes, dimensions)
      ranges = Array.new(dimensions) {[Float::NAN, Float::NAN]}
      nodes.each do |node|
        node.position.each_with_index do |position, index|
          # Bottom range
          ranges[index][0] = position if ranges[index][0].to_f.nan? || position < ranges[index][0]
          # Top range
          ranges[index][1] = position if ranges[index][1].to_f.nan? || position > ranges[index][1]
        end
      end
      ranges
    end
  end

  attr_accessor :position, :nodes

  def initialize(position)
    @position = position
    @mean_distance = nil
    @nodes = []
  end

  def mean_node_distance

    return @mean_distance if @mean_distance

    total_dist = 0.0
    total_nodes = @nodes.size

    total_dist.reduce(0){|sum, node| sum + node.best_distance}

    if total_nodes > 0
      @mean_distance = total_dist/total_nodes
    else
      # if there no nodes in cluster, so the centroid is bad
      @mean_distance = 1.0/0.0
    end

    @mean_distance
  end

  # Finds the average distance of all the nodes assigned to
  # the centroid and then moves the centroid to that position
  def reposition(nodes, centroids)
    return if nodes.empty?
    averages = [0.0] * nodes[0].position.size
    nodes.each do |node|
      node.position.each_with_index do |position, index|
        averages[index] += position
        #Store closest nodes in the centroid object
        centroid.nodes << node
      end
    end
    @position = averages.map {|x| x / nodes.size}
  end

end
