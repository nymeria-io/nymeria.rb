# frozen_string_literal: true

require 'nymeria/company.rb'
require 'nymeria/email.rb'
require 'nymeria/person.rb'

require 'json'
require 'net/http'

API_KEY = ''
BASE_URL = 'https://www.nymeria.io/api/v4'
USER_AGENT = 'nymeria.rb/2.0.4'

# Nymeria is our primary module namespace.
module Nymeria
  class << self
    def request(req)
      req['X-Api-Key'] = API_KEY
      req['User-Agent'] = USER_AGENT
      req
    end
  end
end
