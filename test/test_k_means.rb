require 'helper'

class TestKMeans < Test::Unit::TestCase
  context "A KMeans Instance" do
    
    setup do
      @kmeans = KMeans.new(4)
      @data = Array.new(10) {Array.new(2) {rand}}
    end
  
    should "return an array" do
      assert_kind_of Array, @kmeans.clustify(@data)
    end
    
    should "have 4 centroids" do
      centroids = @kmeans.clustify(@data).size
      assert_equal(4, centroids)
    end
    
    should "return same amount of data that went in" do
      output_data_count = @kmeans.clustify(@data).inject(0) do |sum, n|
        sum += n.size
      end
      assert_equal(@data.size, output_data_count)
    end
    
  end
end
