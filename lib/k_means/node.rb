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
    @similarity_measure = similarity_measure
  end

  def update_closest_centroid(centroids, force = false)
    # If we haven't processed this node we need to give it an initial centroid
    # so that we have something to compare distances against
    calculate_initial_centroid(centroids.first) if (!@closest_centroid || force)  

    updated = false
    centroids.each do |centroid|
      # Check if they are in the same position
      if centroid.position == @position
        updated = update_attributes(centroid, 0.0)
        break
      end

      distance = calculate_distance(centroid)
      if distance < best_distance
        updated = update_attributes(centroid, distance)
      end
    end

    updated == true ? 1 : 0
  end

  def reset!
    @closest_centroid = nil
    @best_distance    = nil
  end

  private

  def update_attributes(closest_centroid, best_distance)
    @closest_centroid, @best_distance = closest_centroid, best_distance
    true
  end

  def calculate_initial_centroid(centroid)
    @closest_centroid = centroid
    @best_distance = calculate_distance(centroid)
  end

  def calculate_distance(centroid)
    begin
      @position.send(@similarity_measure, centroid.position)
    rescue NoMethodError
      raise "Hey, '#{@similarity_measure}' is not a measurement. Read the README for available measurements"
    end
  end

end
