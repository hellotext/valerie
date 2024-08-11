require_relative '../milday'

module Milday
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
      @emails ||= EmailCollection.new
    end
    
    def addresses
      @addresses ||= AddressCollection.new
    end
    
    def phones
      @phones ||= PhoneCollection.new
    end
  end
end
