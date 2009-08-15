require 'benchmark'
require 'rubygems'
require 'ai4r'
require File.dirname(__FILE__) + '/../lib/k_means'

data = Array.new(200) {Array.new(50) {rand(10)}}

puts data.inspect

ai4r_data = Ai4r::Data::DataSet.new(:data_items=> data)

# Clustering can happen in magical ways
# so lets do it over multiple times
n = 2

Benchmark.bm do |x|
  x.report('Mine') do
    a = KMeans.new(4)
    n.times { a.clustify(data) }
  end
  x.report("Ai4R") do
    b = Ai4r::Clusterers::KMeans.new
    n.times { b.build(ai4r_data, 4) }
  end
end