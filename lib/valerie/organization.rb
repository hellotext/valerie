module Valerie
  class Organization
    attr_reader :name, :department
    
    class << self
      def new(*organization)
        if organization.first.is_a?(Hash)
          super(name: organization.first[:name], department: organization.first[:department])
        else
          name, department = organization.flatten
          super(name:, department:)
        end
      end
      
      def from_s(data)
        name, department = data.gsub("ORG:", "").split(";")
        new(name:, department:)
      end
    end
    
    def initialize(name:, department: nil, **options)
      @name, @department = name, department
      @options = options
    end
    
    def to_s
      "ORG:#{@name};#{department_part}"
    end
    
    def present?
      @name.to_s.length > 0 || @department.to_s.length > 0
    end
    
    private
      def department_part
        if @department.to_s.empty?
          fallback_department
        else
          @department
        end
      end
      
      def fallback_department
        " \n"
      end
  end
end
