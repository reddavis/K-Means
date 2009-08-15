class BasicCacheStore
  
  def initialize
    @store = {}
  end
  
  def set(key, data)
    @store[key] = data
  end
  
  def get(key)
    @store[key]
  end
  
end