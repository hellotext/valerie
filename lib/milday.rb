require_relative 'milday/address'
require_relative 'milday/birthday'
require_relative 'milday/email'
require_relative 'milday/gender'
require_relative 'milday/name'
require_relative 'milday/organization'
require_relative 'milday/phone'
require_relative 'milday/vcard'

require_relative 'milday/collection/email_collection'
require_relative 'milday/collection/address_collection'
require_relative 'milday/collection/phone_collection'

module Milday
  VERSION = '0.0.1'.freeze
  
  def self.configuration
    @configuration ||= Configuration.new
  end
  
  def self.configure
    yield(configuration)
  end
  
  class Configuration
    attr_accessor :product, :version, :language
    
    def product
      @product ||= 'Milday www.hellotext.com'
    end
    
    def version
      @version ||= '3.0'
    end
    
    def language
      @language ||= 'EN'
    end
  end
end
