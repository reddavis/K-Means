require 'helper'


class TestKMeans < Test::Unit::TestCase

  context "A KMeans Instance" do

    setup do
      @data = Array.new(3) {Array.new(2) {rand}}
      @kmeans = KMeans.new(@data, :centroids => 2, :distance_measure => :cosine_similarity)
      @kmeans2 = KMeans.new(data, :centroids => 2, :distance_measure => :euclidean_distance)
      @kmeans3 = KMeans.new(data, :centroids => 3, :distance_measure => :euclidean_distance)
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

    should "DBI of 3 clusters less than 2 clusters" do
      assert @kmeans2.davies_bouldin_index > @kmeans3.davies_bouldin_index
    end

  end


  context "A KMeans Instance with specified initial centroids" do
    setup do
      @data = Array.new(3) {Array.new(2) {rand}}

      #@specified_centroids = @data[0..2].map { |d| CustomCentroid.new(d) }
      @kmeans = KMeans.new(@data, :centroids => 3, :distance_measure => :cosine_similarity)
    end

    should "return an inspected array" do
      assert_kind_of(String, @kmeans.inspect)
    end

    should "have 3 centroids" do
      assert_equal(3, @kmeans.centroids.size)
    end

    should "have 3 nodes" do
      assert_equal(3, @kmeans.nodes.size)
    end
  end

  def data
    [
      [ 1.0, 1.0 ],
      [ 2.0, 1.0 ],
      [ 2.0, 1.0 ],
      [ 1.5, 1.0 ],
      [ 1.8, 1.5 ],
      [ 1.2, 1.4 ],
      [ 1.9, 2.0 ],
      [ 1.9, 1.0 ],
      [ 1.0, 1.9 ],
      [ 2.0, 2.0 ],
      [ 4.3, 1.1 ],
      [ 4.8, 1.2 ],
      [ 4.3, 1.5 ],
      [ 4.4, 1.2 ],
      [ 4.1, 1.9 ],
      [ 4.8, 1.7 ],
      [ 4.2, 1.1 ],
      [ 4.4, 1.7 ],
      [ 5.8, 5.2 ],
      [ 5.2, 6.2 ],
      [ 5.5, 6.2 ],
      [ 5.1, 6.2 ],
      [ 5.2, 6.3 ],
      [ 5.8, 6.1 ],
      [ 5.6, 6.3 ],
      [ 5.3, 6.4 ],
      [ 5.5, 6.1 ],
      [ 5.1, 6.2 ],
      [ 5.9, 6.2 ],
      [ 6.2, 5.1 ]
    ]
  end

end
