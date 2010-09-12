module Wordpressto
  require "xmlrpc/client"
  require 'uri'
  require 'mime/types'
  
  class WordpressBlog
    attr_accessor :url, :username, :password, :blog_id

    def initialize(options = { })
      @username = options[:username] if options[:username]
      @password = options[:password] if options[:password]
      @blog_id = options[:blog_id] || 1
      @url = options[:url] if options[:url]
    end
    
    def posts
      @post_collection ||= WordpressPostCollection.new(:conn => self)
    end
    
    def attachments
      @attachments ||= WordpressAttachmentCollection.new(:conn => self)
    end
    
    def get_recent_posts(limit = 10)
      call('metaWeblog.getRecentPosts', blog_id, username, password, limit)
    end

    def get_post(qid)
      call('metaWeblog.getPost', qid, username, password)
    end
    
    def edit_post(qid, attributes, published = nil)
      cargs = ['metaWeblog.editPost', qid, username, password, attributes]
      cargs << published unless published.nil?
      call(*cargs)
    end
    
    def new_post(attributes, published = nil)
      cargs = ['metaWeblog.newPost', blog_id, username, password, attributes]
      cargs << published unless published.nil?
      call(*cargs)
    end
    
    def upload_file(name, mimetype, bits, overwrite = false)
      call('wp.uploadFile', blog_id, username, password, 
           { :name => name, :type => mimetype, :bits => XMLRPC::Base64.new(bits), :overwrite => overwrite })
    end

    private 
    
    def call(*args)
      xmlrpc.call(*args)
    end
    
    def xmlrpc
      @xclient ||= XMLRPC::Client.new2(url)
    end
    
  end
  

  class WordpressBase
    def initialize(options = { })
      @conn = options[:conn] || options[:connection]
    end
    
    private
    
    def conn
      @conn
    end
  end
  
  class WordpressAttachmentCollection < WordpressBase
    def new(attributes)
      WordpressAttachment.new(attributes, :conn => conn)
    end
  end
  
  class WordpressAttachment < WordpressBase
    attr_accessor :name, :mimetype, :file, :filename, :url
    
    def initialize(attributes, options = { })
      super(options)
      self.name = attributes[:name]
      self.filename = attributes[:filename]
      self.mimetype = attributes[:mimetype]
      self.file = attributes[:file]
    end
    
    def save
      ret = conn.upload_file(name, mimetype, bits)
      self.url = ret["url"]
      self
    end
    
    def mimetype
      @mimetype ||= MIME::Types.type_for(name).to_s
    end
    
    def name
      @name ||= File.basename(filename)
    end
    
    private
    
    def bits
      file.read
    end
    
    def file
      @file ||= File.open(filename)
    end
  end
  
  class WordpressPostCollection < WordpressBase
    def find_recent(options = { })
      options = { :limit => 10 }.merge(options)
      posts = conn.get_recent_posts(options[:limit])
      posts.collect { |post|  WordpressPost.new(post, :conn => conn) }
    end
    
    def find(qid, options = { })
      if qid.is_a?(Array)
        qid.collect { |sqid| find(sqid) }
      elsif qid == :recent
        find_recent(options)
      else
        post = conn.get_post(qid)
        WordpressPost.new(post, :conn => conn)
      end
    end
    
    def new(attributes = { })
      WordpressPost.new(attributes, :conn => conn)
    end
    
  end
  
  
  class WordpressPost < WordpressBase
    attr_accessor :title, :description
    attr_accessor :created_at
    attr_accessor :keywords, :categories, :published
    
    def initialize(attributes = { }, options = { })
      super(options)
      self.attributes = attributes
    end
    
    def attributes=(attr)
      symbolized_attr = { }
      attr = attr.each { |k,v| symbolized_attr[k.to_sym] = v }
      attr = symbolized_attr
      @title = attr[:title]
      @keywords = attr[:mt_keywords].to_s.split(/,|;/).collect { |k| k.strip }
      @categories = attr[:categories]
      @description = attr[:description]
      @created_at = attr[:dateCreated]
      @id = attr[:postid]
      @userid = attr[:userid]
      @published = attr[:published]
    end
    
    def id
      @id
    end
    
    def save
      id ? update : create
    end
    
    def update
      conn.edit_post(id, attributes, published)
      self
    end
    
    def create
      @id = conn.new_post(attributes, published)
      self
    end
    
    def publish
      self.published = true
      save
    end
    
    def keywords
      if @keywords.is_a? String
        @keywords = @keywords.split(",")
      elsif @keywords.is_a? Array
        @keywords
      else
        []
      end
    end
    
    def created_at
      @created_at
    end
    
    def categories
      if @categories.nil?
        []
      elsif @categories.is_a?(Array)
        @categories
      elsif @categories.is_a(String)
        @categories = @categories.split(",")
      else
        []
      end
    end
    
    def attributes
      h = { }
      h[:title] = title if title
      h[:description] = description if description
      h[:dateCreated] = created_at if created_at
      h[:mt_keywords] = keywords.join(",")
      h[:categories] = categories if categories
      h
    end
    
    def reload
      if id
        saved_id = id
        self.attributes = conn.posts.find(id).attributes
        @id = saved_id
        true
      end
    end

    
  end
end
