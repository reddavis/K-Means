class Array
  def euclidean_distance(other)
    sum = 0.0
    self.each_index do |i|
      sum += (self[i] - other[i])**2
    end
    Math.sqrt(sum)
  end
  
  def cosine_similarity(other)
    dot_product = dot_product(other)
    normalization = self.cosine_normalize * other.cosine_normalize
        
    dot_product / normalization
  end
  
  def dot_product(other)
    sum = 0.0
    self.each_with_index do |n, index|
      sum += n * other[index]
    end
    
    sum
  end
  
  def cosine_normalize
    sum = 0.0
    self.each do |n|
      sum += n ** 2
    end
    
    Math.sqrt(sum)
  end
end