# validates\_uri\_format\_of

Rails plugin that provides a `validates_uri_format_of` method to `ActiveRecord` models.
You can require or disallow certain components of a URI.

## Installation

Just add the following line to your environment.rb:

    config.gem 'validates_uri_format_of'

## Usage

After installing the plugin, it's used like

    class User < ActiveRecord::Base
      validates_uri_format_of :url,
                              :allow_nil    => true,
                              :require_fqdn => true
    end


## Features

Take a look at the lib/ and test/ directories.

## Credits and license

By [Digineo GmbH](http://www.digineo.de/) under the MIT license.
