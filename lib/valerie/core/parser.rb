require_relative '../../valerie'

module Valerie
  module Core
    module Parser
      def parse(data)
        if data.instance_of?(String)
          from_s(data)
        elsif data.instance_of?(Array)
          from_a(data)
        else
          raise ArgumentError, "Expected String or Array, got #{data.class}"
        end
      end
      
      private
        def from_a(data)
          VCard.new.tap do |vcard|
            if (name = data.find { _1.start_with?("N:") })
              vcard.name = Name.from_s name.split(":").last
            end
            
            if (organization = data.find { _1.start_with?("ORG:") })
              vcard.organization = Organization.from_s(organization)
            end
            
            if (birthday = data.find { _1.start_with?("BDAY:") })
              vcard.birthday = Birthday.from_s(birthday)
            end
            
            if (gender = data.find { _1.start_with?("GENDER:") })
              vcard.gender = gender.split(":").last
            end
            
            data.select { _1.include?("TEL;") }.each do |phone|
              vcard.phones.add(Phone.from_s(phone))
            end
            
            data.select { _1.start_with?("EMAIL;") }.each do |email|
              vcard.emails.add(Email.from_s(email))
            end
          end
        end
        
        def from_s(str)
          vcards = []
          vcard = []
          
          unfold(str).each do |entry|
            if entry.include?("VERSION:")
              vcards << from_a(vcard) unless vcard.empty?
              vcard = []
            else
              vcard << entry
            end
          end
          
          vcards << from_a(vcard)
          
          vcards
        end
        
        UNTERMINATED_QUOTED_PRINTABLE = /ENCODING=QUOTED-PRINTABLE:.*=$/
        
        # Borrowed from https://github.com/brewster/vcardigan
        def unfold(vcard)
          unfolded = []
          
          prior_line = nil
          vcard.lines do |line|
            line.chomp!
            # If it's a continuation line, add it to the last.
            # If it's an empty line, drop it from the input.
            if line =~ /^[ \t]/
              unfolded[-1] << line[1, line.size - 1]
            elsif line =~ /(^BEGIN:VCARD$)|(^END:VCARD$)/
            elsif prior_line && (prior_line =~ UNTERMINATED_QUOTED_PRINTABLE)
              # Strip the trailing = off prior line, then append current line
              unfolded[-1] = prior_line[0, prior_line.length - 1] + line
            elsif line =~ /^$/
            else
              unfolded << line
            end
            prior_line = unfolded[-1]
          end
          
          unfolded
        end
    end
  end
end
