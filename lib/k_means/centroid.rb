class Centroid
  
  class << self
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
    
    def create_ranges(nodes, dimensions)
      ranges = Array.new(dimensions) {[0.0, 0.0]}
      nodes.each do |node|
        node.position.each_with_index do |position, index|
          # Bottom range
          ranges[index][0] = position if position < ranges[index][0]
          # Top range
          ranges[index][1] = position if position > ranges[index][1]
        end
      end
      ranges
    end
  end
  
  attr_accessor :position
  
  def initialize(position)
    @position = position
  end
  
  # Finds the average distance of all the nodes assigned to
  # the centroid and then moves the centroid to that position
  def reposition(nodes, centroids)
    return if nodes.empty?
    averages = [0.0] * nodes[0].position.size
    nodes.each do |node|
      node.position.each_with_index do |position, index|
        averages[index] += position
      end
    end
    @position = averages.map {|x| x / nodes.size}
  end
  
end
