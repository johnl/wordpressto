require File.join(File.dirname(__FILE__), 'spec_helper')

describe WordpressBlog do

  describe "initialize" do
    it "take the :username, :password, :url and :blog_id options" do
      blog = a_wordpress_blog
      blog.username.should == valid_wordpress_blog_options[:username]
      blog.password.should == valid_wordpress_blog_options[:password]
      blog.blog_id.should == valid_wordpress_blog_options[:blog_id]
    end
    
    it "should default to blog_id 1" do
      WordpressBlog.new.blog_id.should == 1
    end
  end

  it "should return an XMLRPC::Client" do
    xmlrpc = a_wordpress_blog.send(:xmlrpc)
    xmlrpc.should be_a_kind_of XMLRPC::Client
  end

  it "should make xmlrpc calls to metaWeblog.getPost" do
    blog = a_wordpress_blog
    blog.send(:xmlrpc).should_receive(:call).once.with('metaWeblog.getPost', 
                                                       999, blog.username, blog.password )
    blog.get_post(999)
  end

  it "should make xmlrpc calls to metaWeblog.getRecentPosts" do
    blog = a_wordpress_blog
    blog.send(:xmlrpc).should_receive(:call).once.with('metaWeblog.getRecentPosts',
                                                       blog.blog_id, blog.username, blog.password,  345)
    blog.get_recent_posts(345)
  end

  describe "edit_post" do

    it "should make xmlrpc calls to metaWeblog.editPost with no published arg by default" do
      blog = a_wordpress_blog
      blog.send(:xmlrpc).should_receive(:call).once.with('metaWeblog.editPost',
                                                         98, blog.username, blog.password,
                                                         valid_wordpress_post_options)
      blog.edit_post(98, valid_wordpress_post_options)
    end

    it "should make xmlrpc calls to metaWeblog.editPost with published = true" do
      blog = a_wordpress_blog
      blog.send(:xmlrpc).should_receive(:call).once.with('metaWeblog.editPost',
                                                         98, blog.username, blog.password,
                                                         valid_wordpress_post_options, true)
      blog.edit_post(98, valid_wordpress_post_options, true)
    end

    it "should make xmlrpc calls to metaWeblog.editPost with published = false" do
      blog = a_wordpress_blog
      blog.send(:xmlrpc).should_receive(:call).once.with('metaWeblog.editPost',
                                                         98, blog.username, blog.password,
                                                         valid_wordpress_post_options, false)
      blog.edit_post(98, valid_wordpress_post_options, false)
    end


  end

  describe "new_post" do 
    it "should make metaWeblog.newPost calls with no published arg by default" do
      blog = a_wordpress_blog
      blog.send(:xmlrpc).should_receive(:call).once.with('metaWeblog.newPost',
                                                         blog.blog_id, blog.username, blog.password,
                                                         valid_wordpress_post_options)
      blog.new_post(valid_wordpress_post_options)
    end

    it "should make metaWeblog.newPost calls with published = true" do
      blog = a_wordpress_blog
      blog.send(:xmlrpc).should_receive(:call).once.with('metaWeblog.newPost',
                                                         blog.blog_id, blog.username, blog.password,
                                                         valid_wordpress_post_options, true)
      blog.new_post(valid_wordpress_post_options, true)
    end

    it "should make metaWeblog.newPost calls with published = false" do
      blog = a_wordpress_blog
      blog.send(:xmlrpc).should_receive(:call).once.with('metaWeblog.newPost',
                                                         blog.blog_id, blog.username, blog.password,
                                                         valid_wordpress_post_options, false)
      blog.new_post(valid_wordpress_post_options, false)
    end

  end

  describe "upload_file" do
    it "should make wp.uploadFile calls" do
      blog = a_wordpress_blog
      xmlrpc_valid_wordpress_upload_options = valid_wordpress_upload_options.merge({
        :bits => XMLRPC::Base64.new(valid_wordpress_upload_options[:bits])
      })
      blog.send(:xmlrpc).should_receive(:call).once.with('wp.uploadFile', blog.blog_id, blog.username, 
                                                         blog.password, 
                                                         hash_including({
                                                                          :name => valid_wordpress_upload_options[:name],
                                                                          :type => valid_wordpress_upload_options[:type],
                                                                          :overwrite => valid_wordpress_upload_options[:overwrite],
                                                                          :bits => an_instance_of(XMLRPC::Base64)
                                                                        }))
      args = [:name, :type, :bits, :overwrite].collect { |k| valid_wordpress_upload_options[k] }
      blog.upload_file(*args)
    end
  end

  it "should return a CategoryCollection" do
    blog = a_wordpress_blog
    blog.categories.should be_a_kind_of CategoryCollection
    blog.categories.conn.should == blog
  end

end

