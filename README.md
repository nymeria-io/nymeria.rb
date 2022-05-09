# Nymeria

[![Gem Version](https://badge.fury.io/rb/nymeria.svg)](https://badge.fury.io/rb/nymeria)

The official ruby gem to interact with the Nymeria service and API.

Nymeria makes it easy to enrich data with contact information such as email
addresses, phone numbers and social links. The ruby gem wraps Nymeria's [public
API](https://www.nymeria.io/developers) so you don't have to.

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

if Nymeria.authenticated?
  puts 'Success!'
end
```

All API endpoints assume an api key has been set. You should set the api key
early in your program. The key will automatically be added to all future
requests.

#### Verify an Email Address

```ruby
require 'nymeria'

Nymeria.api_key = 'ny_your-api-key'

resp = Nymeria.verify('someone@somewhere.com')

if resp.success?
  puts resp.data.result
end
```

#### Enrich Profiles

The enrichment API works with a single profile, or multiple.

```ruby
require 'nymeria'

Nymeria.api_key = 'ny_your-api-key'

resp = Nymeria.enrich({ url: 'github.com/someone' })

if resp.success?
  puts resp.data.emails
end
```

The argument to enrich is a hash with one or more of the following keys:

1. url (a supported profile link, like LinkedIn, Github, Twitter or Facebook)
2. email (a person's email, can be an outdated email)
3. identifier (an identifier, such as a facebook ID "fid:1234" or a LinkedIn ID
   "lid:1234").

Bulk enrichment works much the same way as single enrichment, but you can pass
n-arguments and you will get back a list of n-results.

```ruby
require 'nymeria'

Nymeria.api_key = 'ny_your-api-key'

resp = Nymeria.enrich([ { url: 'github.com/someone' }, { url: 'linkedin.com/in/someoneelse' } ])

if resp.success?
  resp.data.each do |match|
    puts match.result['bio']
    puts match.result['emails']
    puts match.result['phone_numbers']
    puts match.result['social']
  end
end
```

### Search for People

You can query Nymeria's people database for people that match a certain
criteria. You can view previews for each person and "unlock" the complete
profile.

Currently, you can query using any of the following parameters:

1. `q` a raw query which will match keywords in a person's name, title, skills,
   etc.
2. `first_name`
3. `last_name`
4. `title`
5. `company`
6. `skills` a comma separated list of skills.
7. `location` city, state, country, etc.
8. `country` matches country only.

```ruby
require 'nymeria'

Nymeria.api_key = 'ny_your-api-key'

previews = Nymeria.people({ q: 'Ruby on Rails' })

if previews.success?
  # Reveal all people from the search query results.
  people = Nymeria.reveal( previews.data.map(&:uuid) )

  if people.success?
    people.data.each do |match|
      puts match.result['bio']
      puts match.result['emails']
      puts match.result['phone_numbers']
      puts match.result['social']
    end
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
