class AutoSearch 
  
  def self.seed
  	Product.select("id,name,price,picture").find_each do |p|
      name = p.name
      1.upto(name.length) do |n|
         prefix = name[0,n]
         $redis.zadd("suggestions:#{prefix.downcase}",1,p.to_json)
      end
  	end
  end

  def self.terms_for(prefix)
  	 $redis.zrevrange("suggestions:#{prefix.downcase}",0,9)
  end

  def self.add_product_term(product_id)
    product = Product.select("id,name,price,picture").find(product_id) 
    1.upto(product.name.length) do |n|
       prefix = product.name[0,n]
       $redis.zadd("suggestions:#{prefix.downcase}",1,product.to_json)
    end
  end

  def self.remove_product_term(product_id)
    product = Product.select("id,name,price,picture").find(product_id) 
    1.upto(product.name.length) do |n|
       prefix = product.name[0,n]
       $redis.zrem("suggestions:#{prefix.downcase}",product.to_json)
    end
  end
end