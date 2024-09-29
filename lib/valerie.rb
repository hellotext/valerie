require_relative 'valerie/address'
require_relative 'valerie/birthday'
require_relative 'valerie/email'
require_relative 'valerie/gender'
require_relative 'valerie/name'
require_relative 'valerie/organization'
require_relative 'valerie/phone'
require_relative 'valerie/card'

require_relative 'valerie/collection/email_collection'
require_relative 'valerie/collection/address_collection'
require_relative 'valerie/collection/phone_collection'

module Valerie
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
      @product ||= 'Valerie www.hellotext.com'
    end
    
    def version
      @version ||= '3.0'
    end
    
    def language
      @language ||= 'EN'
    end
  end
end
