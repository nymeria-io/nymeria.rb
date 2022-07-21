# Nymeria

[![Gem Version](https://badge.fury.io/rb/nymeria.svg)](https://badge.fury.io/rb/nymeria)

The official ruby gem to interact with Nymeria's service. You can use Nymeria to enrich data with
contact information such as email addresses, phone numbers and social links. The ruby gem wraps
Nymeria's [public API](https://www.nymeria.io/developers) so you don't have to.

![Nymeria makes finding contact details a breeze.](https://www.nymeria.io/assets/images/marquee.png)

## Usage

#### Installation

```bash
$ gem install nymeria
```

#### Setting and Checking an API Key

```ruby
require 'nymeria'

Nymeria.api_key = 'YOUR API KEY GOES HERE'

if Nymeria.authenticated?
  puts 'Success!'
end
```

All actions that interact with the Nymeria service assume an API key has been
set and will fail if a key hasn't been set. A key only needs to be set once and
can be set at the start of your program.

If you want to check a key's validity you can use the CheckAuthentication
function to verify the validity of a key that has been set. If no error is
returned then the API key is valid.

#### Verifying an Email Address

```ruby
require 'nymeria'

Nymeria.api_key = 'YOUR API KEY GOES HERE'

resp = Nymeria.verify('dev@nymeria.io')

if resp.success?
  puts resp.data.result
end
```

You can verify the deliverability of an email address using Nymeria's service.
The response will contain a result and tags.

The result will either be "valid" or "invalid". The tags will give you
additional details regarding the email address. For example, the tags will tell
you if the mail server connection was successful, if the domain's DNS records
are set up to send and receive email, etc.

#### Enriching Profiles

```ruby
require 'nymeria'

Nymeria.api_key = 'YOUR API KEY GOES HERE'

# You can enrich a single record like this.
resp = Nymeria.enrich({ url: 'github.com/nymeriaio' })

if resp.success?
  puts resp.data.emails
end

# You can also pass multiple records as an array to do a bulk enrichment.
resp = Nymeria.enrich([ { url: 'github.com/nymeriaio' }, { url: 'linkedin.com/in/wozniaksteve' } ])

if resp.success?
  resp.data.each do |match|
    puts match.result['bio']
    puts match.result['emails']
    puts match.result['phone_numbers']
    puts match.result['social']
  end
end
```

You can enrich one or more profiles using the enrich function. The enrich
function takes a hash, or an array of hashes. The most common hash parameters to
use are `url` and `email`.

If you want to enrich an email address you can specify an email and the Nymeria
service will locate the person and return all associated data for them.
Likewise, you can specify a supported url via the url parameter if you prefer
to enrich via a url.

At this time, Nymeria supports look ups for the following sites:

1. LinkedIn
1. Facebook
1. Twitter
1. GitHub

Please note, if using LinkedIn urls provide the public profile
LinkedIn url.

Two other common parameters are `filter` and `require`. If you wish to filter out
professional emails (only receive personal emails) you can do so by specifying
`"professional-emails"` as the filter parameter.

The require parameter works by requiring certain kinds of data.  For example, you
can request an enrichment but only receive a result if the profile contains a phone
number (or an email, personal email, professional email, etc). The following are all
valid requirements:

1. "email"
1. "phone"
1. "professional-email"
1. "personal-email"

You can specify multiple requirements by using a command between each requirement.
For example you can require a phone and personal email with: "phone,personal-email"
as the require parameter.

### Searching for People

```ruby
require 'nymeria'

Nymeria.api_key = 'YOUR API KEY GOES HERE'

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

You can perform searches using Nymeria's database of people. The search works using two functions:

1. `people` which performs a search and returns a preview of each person.
1. `reveal` which takes UUIDs of people and returns complete profiles.

Note, using `people` does not consume any credits but using `reveal` will consume credit for each
profile that is revealed.

The hash parameter enables you to specify your search criteria. In particular, you can specify:

1. `q` for general keyword matching text.
1. `location` to match a specific city or country.
1. `company` to match a current company.
1. `title` to match current titles.
1. `has_email` if you only want to find people that have email addresses.
1. `has_phone` if you only want to find people that has phone numbers.
1. `skills` if you are looking to match specific skills.

By default, 10 people will be returned for each page of search results. You can specify the `page`
as part of your hash if you want to access additional pages of people.

You can filter the search results and if you want to reveal the complete details you can do so
by sending the uuids via `reveal`. Please note, credit will be consumed for each person that is revealed.

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
