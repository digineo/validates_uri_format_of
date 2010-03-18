# validates\_uri\_format\_of

Rails plugin that provides a `validates_uri_format_of` method to `ActiveRecord` models.

## Usage

After installing the plugin, it's used like

    class User < ActiveRecord::Base
      validates_uri_format_of :url,
                              :allow_nil    => true,
                              :require_fqdn => true
    end


## Features

Take a look in the lib/validates_uri_format_of.rb

## Credits and license

By [Digineo GmbH](http://www.digineo.de/) under the MIT license.
