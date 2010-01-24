require 'helper'

class TestNode < Test::Unit::TestCase
  context "A Data Instance" do
    
    setup do
      @node = Node.new([4, 4], :euclidean)
    end
  
    should "return an array" do
      assert_kind_of Array, @node.position
    end
    
    should "create an array of nodes" do
      data = Array.new(10) {Array.new(2) {rand}}
      nodes = Node.create_nodes(data, :euclidean)
      assert_kind_of Array, nodes
    end
    
    should "create 10 nodes" do
      data = Array.new(10) {Array.new(2) {rand}}
      nodes = Node.create_nodes(data, :euclidean)
      assert_equal 10, nodes.size
    end
    
    should "initialize closest centroid" do
      a = @node.closest_centroid
      centroids = [Centroid.new([4, 4]), Centroid.new([5, 4])]
      @node.update_closest_centroid(centroids)
      assert_not_equal nil, @node.closest_centroid
    end
    
    should "update closest centroid" do
      centroids = [Centroid.new([5, 4])]
      @node.update_closest_centroid(centroids)
      a = @node.closest_centroid
      @node.update_closest_centroid([Centroid.new([4,4])])
      assert_not_equal a, @node.closest_centroid
      assert_equal 0, @node.best_distance
    end
    
    should "raise error if a false measure is specified" do
      assert_raise RuntimeError do
        Node.new([9,9], :fakey)
      end
    end
        
  end
end