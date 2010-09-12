module Wordpressto
  class Base
    def initialize(options = { })
      @conn = options[:conn] || options[:connection]
    end
    
    def conn
      @conn
    end
  end
end
