module Wordpressto
  class Error < StandardError ; end
  class ConnectionFailure < Error ; end

  class Base
    def initialize(options = { })
      @conn = options[:conn] || options[:connection]
    end
    
    def conn
      @conn
    end
  end
end
