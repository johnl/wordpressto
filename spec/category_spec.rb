require File.join(File.dirname(__FILE__), 'spec_helper')

describe Category do
  describe "create" do
    it "should call wp.newCategory" do
      blog = a_wordpress_blog
      blog.xmlrpc.should_receive(:call).once.with('wp.newCategory', blog.blog_id, blog.username, blog.password,
                                                  hash_including("name" => valid_category_options[:name])).and_return(10)
      blog.categories.create valid_category_options
    end

    it "should return a Category instance with the right id" do
      blog = a_wordpress_blog
      blog.xmlrpc.should_receive(:call).once.and_return(10)
      blog.categories.create(valid_category_options).id.should == 10
    end
  end

  it "should generate a slug from the title if not provided" do
    Category.new(:name => "Blog Posts ").slug.should == "blog-posts"
    Category.new(:name => "Blog Posts", :slug => 'posts').slug.should == "posts"
    Category.new(:name => nil).slug.should be_empty
  end
end
