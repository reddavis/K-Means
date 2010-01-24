require 'helper'

class TestCentroid < Test::Unit::TestCase
  context "A Centroid" do
    
    setup do
      @centroid = Centroid.new([1, 2, 3])
    end
    
    should "return an array" do
      assert_kind_of Array, @centroid.position
    end
    
    should "return an array of centroids" do
      centroids = Centroid.create_centroids(4, create_nodes)
      assert_kind_of Array, centroids
      assert_kind_of Centroid, centroids.first
    end
    
    should "create 4 centroids" do
      centroids = Centroid.create_centroids(4, create_nodes)
      assert_equal 4, centroids.size
    end
    
    should "reposition nodes" do
      nodes = create_nodes
      average_position = [0.0] * nodes[0].position.size
      nodes.each do |node|
        node.position.each_with_index do |position, index|
          average_position[index] += position
        end
      end
      average_position.map! {|x| x / 2}
      @centroid.reposition(create_nodes)
      assert_equal average_position, @centroid.position
    end
      
  end
  
  private
  
  def create_nodes
    Node.create_nodes([[1,2,3], [4,5,6]], :euclidean)
  end
end
