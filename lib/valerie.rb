require 'valerie/address'
require 'valerie/birthday'
require 'valerie/email'
require 'valerie/gender'
require 'valerie/name'
require 'valerie/organization'
require 'valerie/phone'
require 'valerie/card'

require 'valerie/collection/email_collection'
require 'valerie/collection/address_collection'
require 'valerie/collection/phone_collection'

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
