module TagHelper
  def cloud_tags(cutoff = 20, limit = 10)
    @cloud_tags = Tag.group("name").having("count(name) > :cutoff", :cutoff => cutoff).order("count(name) DESC").limit(limit).count() 
  end
end
