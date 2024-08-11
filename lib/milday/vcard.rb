require_relative '../milday'

module Milday
  class VCard
    attr_reader :name, :formatted_name, :organization, :gender
    
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
  end
end
