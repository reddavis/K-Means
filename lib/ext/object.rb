class Object
  
  # Simpler way to handle a random number between to values
  def rand_between(a, b)
    return rand_in_floats(a, b) if a.is_a?(Float) or b.is_a?(Float)
    range = (a - b).abs + 1
    rand(range) + [a,b].min
  end
  
  # Handles non-integers
  def rand_in_floats(a, b)
    range = (a - b).abs
    (rand * range) + [a,b].min
  end
  
end