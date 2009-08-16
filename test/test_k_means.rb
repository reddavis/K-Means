require 'helper'

class TestKMeans < Test::Unit::TestCase
  context "A KMeans Instance" do
    
    setup do
      @data = Array.new(200) {Array.new(2) {rand}}
#      @data = [[1,1], [1,2], [1,1], [10000, 10000]]
      @kmeans = KMeans.new(@data, :centroids => 4)
    end
  
    should "return an array" do
      assert_kind_of String, @kmeans.inspect
    end
    
    should "have 4 centroids" do
      assert_equal 4, @kmeans.centroids.size
    end
    
    should "have 200 nodes" do
      assert_equal 200, @kmeans.nodes.size
    end
        
  end
end
