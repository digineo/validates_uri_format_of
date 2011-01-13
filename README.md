# validates_uri_format_of

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

* `:schemes` – allowed URI schemes. Default: `['http','https']`
* `:require_scheme` – Default: `true`
* `:require_host` – Default: `true`
* `:require_path` – Default: `true`
* `:require_fqdn` – enforce a fully qualified domain name? Default: `nil`
* `:with_port` – Default: `nil`
* `:with_query` – `true` requires a query string (e.g. '?query'), `false` does not allow a query string. Default: `nil` (no check)
* `:with_fragment` – `true` requires a fragment string (e.g. '#fragment'), `false` does not allow a fragment string. Default: `nil` (no check)
* `:with_auth` – `true` requires authentication info (e.g. 'http://user:pass@example.com/'), `false` does not allow a fragment string. Default: `nil` (no check)
* `:on` – Specifies when this validation is active (default is `:save`, other options `:create`, `:update`).
* `:if` – Specifies a method, proc or string to call to determine if the validation should
  occur (e.g. `:if => :allow_validation`, or `:if => Proc.new { |user| user.signup_step > 2 }`).
  The method, proc or string should return or evaluate to a true or false value.
* `:unless` – Specifies a method, proc or string to call to determine if the validation should
  not occur (e.g. `:unless => :skip_validation`, or `:unless => Proc.new { |user| user.signup_step <= 2 }`).
  The method, proc or string should return or evaluate to a true or false value.



Do also a look at the lib/ and test/ directories.

## Credits and license

By [Digineo GmbH](http://www.digineo.de/) under the MIT license.
