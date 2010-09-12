module Wordpressto
  class Category
    attr_reader :id, :category_id, :description, :name, :url, :rss_url

    def initialize(attributes = {})
      @id = attributes[:id]
      @category_id = attributes[:category_id]
      @description = attributes[:description]
      @name = attributes[:name]
      @url = attributes[:url]
      @rss_url = attributes[:rss_url]
    end
    
    def self.new_from_xmlrpc(attributes)
      self.new :id => attributes['categoryId'], :category_id => attributes['parentId'],
      :description => attributes['description'], :name => attributes['categoryName'],
      :url => attributes['htmlUrl'], :rss_url => attributes['rssUrl']
    end
  end
end

