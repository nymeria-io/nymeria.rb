# frozen_string_literal: true

require 'nymeria/company'
require 'nymeria/email'
require 'nymeria/person'

require 'json'
require 'net/http'

# Nymeria is our primary module namespace.
module Nymeria
  BASE_URL = 'https://www.nymeria.io/api/v4'
  USER_AGENT = 'nymeria.rb/2.2.0'

  class << self
    def request(req)
      req['X-Api-Key'] = defined?(API_KEY) ? API_KEY : ''
      req['User-Agent'] = USER_AGENT
      req
    end
  end
end
