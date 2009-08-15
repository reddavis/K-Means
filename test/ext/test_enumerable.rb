require 'helper'

class TestEnumerable < Test::Unit::TestCase
  context "Euclidean Distance" do
    
    should "return 5" do
      assert_equal 5, [10].euclidean_distance([5])
    end
    
  end
end
