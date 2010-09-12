require 'rubygems'
require 'lib/wordpressto.rb'
include Wordpressto

def valid_wordpress_blog_options
  { :username => 'lily', :password => 'lilybeans', :url => 'http://example.com', :blog_id => 666 }
end
  
def valid_wordpress_post_options
  { :title => "Test Post", :description => "The text of the post", :dateCreated => Time.at(1284243726),
    :mt_keywords => 'test,post,example', :categories => 'blog' }
end

def a_wordpress_blog
  WordpressBlog.new(valid_wordpress_blog_options)
end

def valid_wordpress_upload_options
  { :name => "A file", :type => "application/octet-stream",
    :bits => "12345678910", :overwrite => false }
end

def valid_category_options
  { :name => 'Posts', :slug => 'posts', :parent_id => nil, :description => "Blog posts" }
end
