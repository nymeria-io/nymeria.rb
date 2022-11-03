# frozen_string_literal: true

require_relative './company.rb'
require_relative './email.rb'
require_relative './person.rb'

require 'json'
require 'net/http'

API_KEY = ''
BASE_URL = 'https://www.nymeria.io/api/v4'
USER_AGENT = 'nymeria.rb/3.0'

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
