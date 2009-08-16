require 'helper'

class TestObject < Test::Unit::TestCase
  context "Random Number Between" do
    
    should "return a number between 10 and 20" do
      n = rand_between(10, 20)
      assert_between(10..20, n)
    end
    
    should "return a float between 10.0 and 10.9" do
      n = rand_between(10.0, 10.9)
      assert_between(10..11, n)
      assert_kind_of Float, n
    end
    
  end
end
