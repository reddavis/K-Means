require File.dirname(__FILE__) + '/../lib/k_means'
require 'rubygems'
require 'ruby-prof'

data = Array.new(100) {Array.new(2) {rand}}

result = RubyProf.profile do
  a = KMeans.new(data)
end

printer = RubyProf::GraphPrinter.new(result)
printer.print(STDOUT, 0)