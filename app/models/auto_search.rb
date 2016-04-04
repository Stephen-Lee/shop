class AutoSearch 
  
  def self.seed
  	Product.find_each do |p|
      name = p.name
      1.upto(name.length - 1) do |n|
         prefix = name[0,n]
         $redis.zadd("su:#{prefix.downcase}",1,p)
      end
  	end
  end

  def self.terms_for(prefix)
  	 $redis.zrevrange("suggestions:#{prefix.downcase}",0,9)
  end
end