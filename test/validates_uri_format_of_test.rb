require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_support/core_ext/string/inflections'
require "#{File.dirname(__FILE__)}/../init"

module ModelBuilder
  begin  # Rails 3
    include ActiveModel::Validations
  rescue NameError  # Rails 2.*
    # ActiveRecord validations without database
    # Thanks to http://www.prestonlee.com/archives/182
    def save() end
    def save!() end
    def new_record?() false end
    def update_attribute() end  # Needed by Rails 2.1.
    def initialize
      @errors = ActiveRecord::Errors.new(self)
      def @errors.[](key)  # Return errors in same format as Rails 3.
        Array(on(key))
      end
    end
    
    def self.included(base)
      base.send :extend,  ClassMethods
      base.send :include, ActiveRecord::Validations
      base.send :extend, ValidatesUriFormatOf
    end
    
    module ClassMethods
      def human_name() end
      def human_attribute_name(_) end
      def self_and_descendants_from_active_record() [self] end
      def self_and_descendents_from_active_record() [self] end  # Needed by Rails 2.2.
    end
    
  end
end

def define_model(typ, options={})
  eval "
    class Model#{typ.to_s.camelize}
      include ModelBuilder
      attr_accessor :#{typ}
      validates_uri_format_of :#{typ}, #{options.inspect}
    end
  "
end

define_model :url_complete

# alles verbieten, was zu verbieten geht
define_model :url_simple,
  :with_auth     => false,
  :with_port     => false,
  :with_query    => false,
  :with_fragment => false

# FTP mit Zugangsdaten
define_model :url_with_ftp,
  :schemes       => ['ftp'],
  :with_auth     => true,
  :with_query    => false,
  :with_fragment => false

define_model :url_without_domain,
  :require_fqdn => false

define_model :url_with_fqdn,
  :require_fqdn => true

define_model :url_without_port,
  :with_port => false

define_model :url_without_query,
  :with_query => false

define_model :url_without_fragment,
  :with_fragment => false

define_model :url_without_ip,
  :require_fqdn => true

define_model :custom_url,
  :message => 'custom message'

define_model :nil_url,
  :allow_nil => true

define_model :empty_url,
  :allow_empty => true

class ValidatesUrlFormatOfTest < Test::Unit::TestCase
  
  def test_simple
    assert_urls_valid :url_simple,
      'http://192.168.2.1/',
      "http://example.com/",
      "http://www.example.com/a/",
      "https://www.example.com/a/b/a-index.html"
    assert_urls_invalid :url_simple,
      'http://example.com/?abc',
      'http://www.example.com/#foo',
      'http://user:pass@example.com/'
  end
  
  def test_without_ip
    assert_urls_valid :url_without_ip, 
      'http://example.com/',
      'http://example.com:5321/',
      'http://example.com/index',
      'http://example.com/index?foo=bar&x=y',
      'http://example.com/index#anchor',
      'http://example.com/index?foo=bar&x=y#anchor'
      
    assert_urls_invalid :url_without_ip,
      'http://1.1.1/',
      'http://192.168.2.1/'
  end
  
  def test_without_port
    assert_urls_valid :url_without_port, 
      'http://example.com/',
      'http://example.com:/', # Port ist leer, also nicht angegeben. Dann wird der Default-Port verwendet.
      'http://1.1.1.1/index',
      'http://123.123.123.123/index?foo=bar&x=y',
      'http://example.com/index#anchor',
      'http://example.com/index?foo=bar&x=y#anchor'
      
    assert_urls_invalid :url_without_port,
      'http://1.1.1.1:1234/index',
      'http://123.123.123.123:80/index?foo=bar&x=y',
      'http://example.com:70000/index#anchor',
      'http://example.com:999/index?foo=bar&x=y#anchor'
  end
  
  def test_without_query
    assert_urls_valid :url_without_query, 
      'http://example.com/',
      'http://1.1.1.1/index',
      'http://example.com:421/index#anchor'
      
    assert_urls_invalid :url_without_query,
      'http://example.com?',
      'http://example.com/?',
      'http://1.1.1.1:1234/index?a=b'
  end
  
  def test_without_anchor
    assert_urls_valid :url_without_fragment,
      'http://example.com/',
      'http://1.1.1.1/index',
      'http://top:secret@example.com:421/stuff/?foo=bar'
      
    assert_urls_invalid :url_without_fragment,
      'http://example.com#',
      'http://example.com/#',
      'http://1.1.1.1/index#chapter-2'
  end
  
  def test_should_allow_valid_urls
    assert_urls_valid :url_complete,
      'http://example.com/',
      'http://www.example.com/',
      'http://sub.domain.example.com/',
      'http://bbc.co.uk/',
      'http://example.com/?foo',
      'http://example.com:8000/',
      'http://www.sub.example.com/page.html?foo=bar&baz=%23#anchor',
      'http://user:pass@example.com/',
      'http://user:@example.com/',
      'http://example.com/~user',
      'http://example.xy/',  # Not a real TLD, but we're fine with anything of 2-6 chars
      'http://example.museum/',
      'http://1.0.255.249/',
      
      # Explicit TLD root period with path
      'http://example.com./',
      'http://example.com./foo',
      
      'http://1.2.3.4:80/',
      'HttP://example.com/',
      'https://example.com/',
      'http://example.com/?url=http://example.com',
#      'http://räksmörgås.nu/',  # IDN
      'http://xn--rksmrgs-5wao1o.nu/'  # Punycode

    #assert_urls_valid :nil_url, nil
    assert_urls_valid :empty_url, ''
  end
  
  def test_should_reject_invalid_urls
    assert_urls_invalid :url_complete,
      nil, 1, "", " ", "url",
      'http://example.com',
      "www.example.com",
      "http://ex ample.com",
      "http://example.com/foo bar",
      'http://example.com?foo',
      'http://example.com:8000',
      'http://user:pass@example.com',
      'http://user:@example.com',
      'http://u:u:u@example.com',
      'http://r?ksmorgas.com',
      
      # Explicit TLD root period without path
      'http://example.com.',
      
      # These can all be valid local URLs, but should not be considered valid
      # for public consumption.
      "http://example",
      "http://example.c",
      'http://example.toolongtld',
      
      'http://256.0.0.1' # TODO ;-)
  end
  
  def test_can_override_defaults
    object = build_object(:custom_url, "x")
    assert_equal ['custom message'], object.errors[:custom_url]
  end
  
  private
  
  def build_object(attribute,value)
    object = "model_#{attribute}".camelize.constantize.new
    object.send "#{attribute}=", value
    object.valid?
    object
  end
  
  def assert_urls_valid(attribute, *urls)
    for url in urls
      object = build_object(attribute, url)
      puts object.errors.inspect unless object.errors.empty?
      assert object.errors[attribute].empty?, "#{url.inspect} should have been accepted (#{object.errors[attribute]})"
    end
  end
  
  def assert_urls_invalid(attribute, *urls)
    for url in urls
      object = build_object(attribute, url)
      
      assert !object.errors[attribute].empty?, "#{url.inspect} should have been rejected"
    end
  end
  
end
