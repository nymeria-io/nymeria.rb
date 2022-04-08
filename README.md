# Nymeria

[![Gem Version](https://badge.fury.io/rb/nymeria.svg)](https://badge.fury.io/rb/nymeria)

The official Ruby gem to interact with the Nymeria service and API.

![Nymeria makes finding contact details a breeze.](https://www.nymeria.io/assets/images/marquee.png)

## Usage

#### Installation

```bash
$ gem install nymeria
```

#### Set and Check an API Key.

```ruby
require 'nymeria'

Nymeria.api_key = 'ny_your-api-key'

if Nymeria.check_authentication.success?
  puts "OK!"
end
```

All API endpoints assume an auth key has been set. You should set the auth key
early in your program. The key will automatically be added to all future
requests.

#### Verify an Email Address

```ruby
require 'nymeria'

Nymeria.api_key = 'ny_your-api-key'

resp = Nymeria.verify("someone@somewhere.com")

if resp.success?
  puts resp.data.result
end
```

At this time only professional email addresses are supported by the API.

#### Enrich a Profile

```ruby
require 'nymeria'

Nymeria.api_key = 'ny_your-api-key'

resp = Nymeria.enrich("github.com/someone")

if resp.success?
  puts resp.data.emails
end
```

The enrich API works on a profile by profile basis. If you need to enrich
multiple profiles at once you can use the bulk enrichment API.

#### Bulk Enrichment of Profiles

```ruby
require 'nymeria'

Nymeria.api_key = 'ny_your-api-key'

resp = Nymeria.enrich([ { url: "github.com/someone" }, { url: "linkedin.com/in/someoneelse" } ])

if resp.success?
  resp.data.each do |match|
    puts match
  end
end
```

## License

MIT License

Copyright (c) 2022, Nymeria LLC.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
