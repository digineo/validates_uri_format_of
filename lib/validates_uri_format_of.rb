module ValidatesUriFormatOf
  REGEXP_FQDN = /^(xn--)?[^\W_]+([-.][^\W_]+)*\.[a-z]{2,6}\.?$/i
  
  COMPONENTS = {
     # Komponenten, bei denen angegeben werden kann, ob etwas explizit
     # angegeben werden muss oder nicht angegeben werden darf oder
     # ob dies egal ist.
    :with => {
    
      # Schlüssel sind unsere eigenen Bezeichnungen,
      # Werte die Bezeichnungen von URI, wobei URI nicht
      # direkt befragt wird, wenn der Wert nil ist.
      :query => :query,
      :user => :user,
      :password => :password,
      :auth => :userinfo, #####
      :fragment => :fragment,
      :port => nil
    },
    :require => {
      :scheme => :scheme,
      :host   => :host,
      :path   => :path
    }
  }
  
  DEFAULT_CONFIGURATION = {
    :schemes        => ['http','https'],
    
    :require_scheme => true,
    :require_host   => true,
    :require_path   => true,
    
    :require_fqdn   => nil,
    
    :with_port      => nil, # URI gibt immer einen Port zurück, auch, wenn dieser nicht explizit angegeben wurde.
    :with_query     => nil,
    :with_user      => nil,
    :with_password  => nil,
    :with_fragment  => nil,   # Anchor
    
    :with_auth      => nil,
    :on             => :save
  }
  
  
  def validates_uri_format_of(*attr_names)
    configuration = {
      :on             => :save
    }.merge(DEFAULT_CONFIGURATION)
    
    configuration.update(attr_names.extract_options!)
    #validates_each(attr_names, configuration) do |record, attr_name, value|
    validates_each(attr_names, :allow_nil => configuration[:allow_nil], :allow_blank => configuration[:allow_empty]) do |record, attr_name, value|
      begin
        raise(URI::InvalidURIError, "cannot be a #{value.class}") unless [NilClass, String].include?(value.class)
        
        for meth in [:nil, :empty]
          if value.send("#{meth}?")
            if configuration[:"allow_#{meth}"]
              next
            else
              raise URI::InvalidURIError, "cannot be #{meth}" 
            end
          end
        end
        
        uri = URI.parse(value)
        # check required fields
        for key in COMPONENTS[:require].keys
          if configuration[:"require_#{key}"] && uri.send(COMPONENTS[:require][key]).to_s.empty?
            raise URI::InvalidURIError, "#{key} missing" 
          end
        end
        
        if configuration[:require_fqdn] && uri.host !~ REGEXP_FQDN
          raise URI::InvalidURIError, "host must be FQDN" 
        end
        
        
        # URI.parse(value).port gibt immer einen Port zurück, auch, wenn
        # dieser nicht explizit angegeben wurde.
        # 
        # URI.split(value) gibt ein Array wie folgt zurück:
        #  * Scheme
        #  * Userinfo
        #  * Host
        #  * Port
        #  * Registry
        #  * Path
        #  * Opaque
        #  * Query
        #  * Fragment
        with_port = configuration[:with_port]
        port_empty = URI.split(value)[3].to_s.empty?
        
        if port_empty && with_port
          raise URI::InvalidURIError, "port required"
        elsif !port_empty && (with_port==false)
          raise URI::InvalidURIError, "port not allowed"
        end
        
        
        # check scheme
        raise URI::InvalidURIError, "invalid scheme" unless configuration[:schemes].include?(uri.scheme.to_s.downcase)
        
        # check fields
        for key in COMPONENTS[:with].keys
          should = configuration[:"with_#{key}"]
          next if should.nil?
          
          next unless COMPONENTS[:with][key] # Wenn nil, dann findet die Überprüfung woanders statt
          value = uri.send(COMPONENTS[:with][key])
          empty = value.to_s.empty?
          
          if empty && should
            raise URI::InvalidURIError, "#{key} required"
          elsif !empty && (should==false)
            raise URI::InvalidURIError, "#{key} not allowed"
          end
        end
        
        if uri.to_s =~ /\#$/
          case configuration[:with_fragment]
            when true
              raise URI::InvalidURIError, "fragment required"
            when false
              raise URI::InvalidURIError, "fragment not allowed"
          end
        end
        
        if (uri.to_s =~ /\?$/) && (configuration[:with_query] == false)
          raise URI::InvalidURIError, "fragment not allowed"
        end
      rescue URI::InvalidURIError => e
        record.errors.add(attr_name, :invalid, :default => (configuration[:message]||e.message), :value => value)
      end
    end
  end
  
end

ActiveRecord::Base.extend(ValidatesUriFormatOf)
