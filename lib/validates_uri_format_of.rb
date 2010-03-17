module ValidatesUriFormatOf
  
  def validates_format_of(*attr_names)
    configuration = {
      :schemes        => ['http','https'],
      :require_scheme => true,
      :require_host   => true,
      :require_path   => true,
      :with_query     => nil,
      :with_user      => nil,
      :with_password  => nil,
      :on             => :save
    }
    configuration.update(attr_names.extract_options!)
    
    validates_each(attr_names, configuration) do |record, attr_name, value|
      
      next if configuration[:allow_nil]   && value.nil?
      next if configuration[:allow_empty] && value.empty?
      
      begin
        uri = URI.parse(value)
        
        # check required fields
        for key in %w(path host protocol)
          if configuration["require_#{key}".to_sym] && uri.send(key).to_s.empty?
            raise URI::InvalidURIError, "#{key} missing" 
          end
        end
        
        # check scheme
        if uri.scheme
          raise URI::InvalidURIError, "invalid scheme" unless configuration[:schemes].include?(uri.scheme)
        end
        
        # check fields
        for key in %w(user password query)
          should = configuration["with_#{key}".to_sym]
          next if should.nil?
          
          value = uri.send(key)
          empty = value.to_s.empty?
          
          if empty && should
            raise URI::InvalidURIError, "#{key} required"
          elsif !empty && !should
            raise URI::InvalidURIError, "#{key} not allowed"
          end
        end
        
      rescue URI::InvalidURIError
        record.errors.add(attr_name, :invalid, :default => configuration[:message], :value => value)
      end
    end
  end
  
end

ActiveRecord::Base.extend(ValidatesUriFormatOf)
