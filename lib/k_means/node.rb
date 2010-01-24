class Node
  
  class << self
    def create_nodes(data, similarity_measure)
      nodes = []
      data.each do |position|
        nodes << new(position, similarity_measure)
      end
      nodes
    end
  end
  
  attr_accessor :position, :best_distance, :closest_centroid
  
  def initialize(position, similarity_measure)
    @position = position
    @similarity_measure = validate_similarity_measure(similarity_measure)
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
    case @similarity_measure
    when :euclidean
      @position.euclidean_distance(centroid.position)
    when :cosine
      @position.cosine_similarity(centroid.position)
    end
  end
  
  def validate_similarity_measure(similarity_measure)
    supported_measure = [:euclidean, :cosine]
    if !supported_measure.include?(similarity_measure)
      raise "Hey! You have specified an unsupported similarity measure."
    end
    similarity_measure
  end
  
end