$: << File.dirname(__FILE__)
require 'rubygems'
require 'basic_cache_store'
require 'ext/enumerable'

class KMeans
  
  def initialize(k=4, options={})
    @k = k
    @verbose = options[:verbose] == true ? true : nil
    @last_matches = nil
  end
  
  def clustify(data)
    @data = data
    place_centroids
    perform_cluster_process
    @best_matches
  end
  
  private
  
  def get_best_distance(data_index, centroid_index, data)
    if cached_data = @cache.get("#{data_index}_#{centroid_index}")
      cached_data
    else
      data.euclidean_distance(@centroids[centroid_index])
    end
  end
  
  def set_best_distance(data_index, centroid_index, data)
    @cache.set("#{data_index}_#{centroid_index}", data.euclidean_distance(@centroids[centroid_index]))
  end
  
  def perform_cluster_process
    100.times do |t|
      verbose_message("Iteration #{t}")
      
      # Prepare best matches array
      @best_matches = create_best_matches_array
      # A little bit of caching
      @cache = BasicCacheStore.new
      
      # See which centroid is closest to which data
      @data.each_with_index do |data, index|
        best_match = 0
        
        @k.times do |i|
          # Calculate the distance between the centroid and the data
          distance = data.euclidean_distance(@centroids[i])
          # Check to see if our new distance is better than what we had before
          if distance < get_best_distance(index, best_match, data)#data.euclidean_distance(@centroids[best_match])
            best_match = i
            set_best_distance(index, best_match, data)
          end #if distance...
        end #@k.times
        @best_matches[best_match] << index
      end #@data.each_with...
      
      # Stop the loop if centroids have stopped moving
      break if @last_matches == @best_matches
      @last_matches = @best_matches
      
      reposition_centroids
    end
  end
  
  # Move the centroids to the average of their surrounding data
  def reposition_centroids
    @k.times do |i|
      averages = [0.0] * @data[0].size # The average data
      # Here we create an average of all the data in @best_matches[i]
      # and then move the centroid (basically replacing the centroids own data with the average)
      # i.e the data is the posistion of the element, if that makes sense?)
      if @best_matches[i].size > 0 # Check the centroid has any matches
        @best_matches[i].each do |data_index|
          @data[data_index].each_with_index do |data, index| 
            averages[index] += data
          end
        end 
        
        # Calculate last part of the average
        averages.each do |average|
          average /= @best_matches[i].size
        end
        @centroids[i] = averages
      end #if @best_matches
      
    end
  end
  
  def place_centroids
    @centroids = []
    ranges = create_ranges
    
    @k.times do |i|
      line_size = @data.first.size
            
      ranges.each do |range|
        group = []
        line_size.times do |n|
          group << rand * (range[1] - range[0]) + range[0]
        end
        @centroids << group
      end
    end
  end
  
  # Calculate the ranges for each points
  def create_ranges
    ranges = []
    @data.each do |line|
      ranges << [line.max, line.min]
    end
    ranges
  end
  
  def verbose_message(message)
    puts message if @verbose
  end
  
  def create_best_matches_array
    array = []
    @k.times { array << []}
    array
  end
    
end