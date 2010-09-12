require 'wordpressto/category'
module Wordpressto
  class CategoryCollection < Base
    include Enumerable

    def initialize(*args)
      super(*args)
    end

    def all
      @categories ||= load
    end
    
    # retrieve the categories via xmlrpc
    def load
      cats = []
      conn.call('wp.getCategories', conn.blog_id, conn.username, conn.password).each do |c|
        cats << Category.new_from_xmlrpc(c, :conn => conn)
      end
      @categories = cats
    end

    def [](i)
      all[i]
    end

    def each
      all.each { |c| yield c }
    end

    def create(attributes)
      new_cat = Category.new(attributes, :conn => conn)
      new_cat.save
      new_cat
    end
  end
end
