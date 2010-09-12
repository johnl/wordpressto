require 'wordpressto/category'
module Wordpressto
  class CategoryCollection < Base
    def initialize(*args)
      super(*args)
      @categories = []
    end
    
    # retrieve the categories via xmlrpc
    def load
      cats = []
      conn.call('wp.getCategories', conn.blog_id, conn.username, conn.password).each do |c|
        cats << Category.new_from_xmlrpc(c)
      end
      @categories = cats
    end
  end
end
