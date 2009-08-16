class Node
  
  class << self
    def create_nodes(data)
      data.inject([]) {|array, position| array << new(position)}
    end
  end
  
  attr_accessor :position, :best_distance, :closest_centroid
  
  def initialize(position)
    @position = position
  end
  
  def update_closest_centroid(centroids)
    calculate_initial_centroid(centroids.first) unless @closest_centroid
    updated = false
    centroids.each do |centroid|
      distance = calculate_distance(centroid)
      if distance < best_distance
        updated = true
        @closest_centroid = centroid
        @best_distance = distance
      end
    end
    updated == true ? 1 : 0
  end
    
  private
  
  def calculate_initial_centroid(centroid)
    @closest_centroid = centroid
    @best_distance = calculate_distance(centroid)
  end
  
  def calculate_distance(centroid)
    @position.euclidean_distance(centroid.position)
  end
  
end