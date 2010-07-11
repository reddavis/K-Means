require 'helper'

class TestKMeans < Test::Unit::TestCase
  context "A KMeans Instance" do

    setup do
      @data = Array.new(3) {Array.new(2) {rand}}
      @kmeans = KMeans.new(@data, :centroids => 2, :distance_measure => :cosine_similarity)
    end

    should "return an array" do
      assert_kind_of String, @kmeans.inspect
    end

    should "have 2 centroids" do
      assert_equal 2, @kmeans.centroids.size
    end

    should "have 200 nodes" do
      assert_equal 3, @kmeans.nodes.size
    end

  end

  context "A KMeans Instance with specified initial centroids" do
    setup do
      @data = Array.new(3) {Array.new(2) {rand}}
      class CustomCentroid
        attr_accessor :position
        def initialize(position); @position = position; end
        def reposition(nodes, centroid_positions); end
      end

      @specified_centroids = @data[0..2].map { |d| CustomCentroid.new(d) }
      @kmeans = KMeans.new(@data, :centroid_positions => @specified_centroids, :distance_measure => :cosine_similarity)
    end

    should "return an array" do
      assert_kind_of String, @kmeans.inspect
    end

    should "have 3 centroids" do
      assert_equal 3, @kmeans.centroids.size
   end

    should "have 3 nodes" do
      assert_equal 3, @kmeans.nodes.size
    end
  end
end
