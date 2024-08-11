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

require_relative 'milday/core/parser'

module Milday
  VERSION = '0.0.1'.freeze
end
