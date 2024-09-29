require_relative '../valerie'
require_relative 'core/parser'

module Valerie
  class VCard
    extend Core::Parser
    
    attr_reader :name, :formatted_name, :organization, :gender, :birthday
    
    def name=(parts)
      if parts.instance_of?(Name)
        @name = parts
      else
        @name = Name.new parts
      end
      
      if (@name.first_name || @name.last_name) && @formatted_name.nil?
        @formatted_name = "#{@name.first_name} #{@name.last_name}".strip
      end
      
      @name
    end
    
    def organization=(*args)
      if args.first.instance_of?(Organization)
        @organization = args.flatten.first
      else
        @organization = Organization.new(*args)
      end
    end
    
    def gender=(value)
      @gender = value.is_a?(Gender) ? value : Gender.new(value)
    end
    
    def birthday=(value)
      @birthday = value.is_a?(Birthday) ? value : Birthday.new(value)
    end
    
    def emails
      @emails ||= Collection::EmailCollection.new
    end
    
    def addresses
      @addresses ||= Collection::AddressCollection.new
    end
    
    def phones
      @phones ||= Collection::PhoneCollection.new
    end
    
    def to_s
      to_a.join("\r\n")
    end
    
    def to_a
      parts = [
        'BEGIN:VCARD',
        "VERSION:#{Valerie.configuration.version}",
        "PRODID:-//#{Valerie.configuration.product}//#{Valerie.configuration.language}",
      ]
      
      parts << @name.to_s if @name
      parts << @organization.to_s if @organization
      parts << @birthday.to_s if @birthday
      parts << @gender.to_s if @gender
      
      emails.each do |email|
        parts << email.to_s
      end
      
      phones.each do |phone|
        parts << phone.to_s
      end
      
      addresses.each do |address|
        parts << address.to_s
      end
      
      parts << 'END:VCARD'
      parts
    end
  end
end
