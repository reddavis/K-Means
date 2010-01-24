require 'helper'

class TestArray < Test::Unit::TestCase
  context "Euclidean Distance" do
    should "return 5" do
      assert_equal 5, [10].euclidean_distance([5])
    end
  end
  
  context "Cosine Similarity" do
    should "return 1" do
      assert [5,5].cosine_similarity([5,5]) > 0.9   # Irrational numbers, ugh!
    end
  end
  
  context "Dot Product" do
    should "return 50" do
      assert_equal 50, [5,5].dot_product([5,5])
    end
  end
end
