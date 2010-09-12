require File.join(File.dirname(__FILE__), 'spec_helper')

describe CategoryCollection do
  it "should retrieve categories via xmlrpc" do
    blog = a_wordpress_blog
    blog.xmlrpc.should_receive(:call).once.with('wp.getCategories', blog.blog_id, blog.username, blog.password).and_return([{}, {}, {}])
    cats = blog.categories.load
    cats.size.should == 3
    cats.first.should be_a_kind_of Category
  end
end
