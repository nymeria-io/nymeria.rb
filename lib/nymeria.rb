# frozen_string_literal: true

require 'json'
require 'net/http'

BASE_URL = 'https://www.nymeria.io/api/v3'
USER_AGENT = 'nymeria.rb/1.0'

# Nymeria is our primary module namespace.
module Nymeria
  class << self
    attr_accessor :api_key

    def request(req)
      req['Content-Type'] = 'application/json'
      req['X-Api-Key'] = api_key
      req['User-Agent'] = USER_AGENT
      req
    end
  end

  def self.check_authentication
    uri = URI("#{BASE_URL}/check-authentication")
    req = request(Net::HTTP::Post.new(uri))

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    response = JSON.parse(res.body)

    # Use an open struct here?
    OpenStruct.new(
      success?: response['status'] == 'success',
      error: response['developer_message']
    )
  rescue => e
    OpenStruct.new(
      success?: false,
      error: "#{e}"
    )
  end

  def self.verify(email)
    uri = URI("#{BASE_URL}/verify")
    req = request(Net::HTTP::Post.new(uri))
    req.body = JSON.dump({ email: email })

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    response = JSON.parse(res.body)

    # Use an open struct here?
    OpenStruct.new(
      success?: response['status'] == 'success',
      usage: OpenStruct.new(response['usage']),
      data: OpenStruct.new(response['data'])
    )
  rescue => e
    OpenStruct.new(
      success?: false,
      error: "#{e}"
    )
  end

  def self.enrich(url, identifier = '')
    uri = URI("#{BASE_URL}/enrich")
    req = request(Net::HTTP::Post.new(uri))
    req.body = JSON.dump({ url: url, identifier: identifier })

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    response = JSON.parse(res.body)

    # Use an open struct here?
    OpenStruct.new(
      success?: response['status'] == 'success',
      usage: OpenStruct.new(response['usage']),
      data: OpenStruct.new(response['data'])
    )
  rescue => e
    OpenStruct.new(
      success?: false,
      error: "#{e}"
    )
  end

  def self.bulk_enrich(people)
    people = [people] unless people.is_a?(Array)

    uri = URI("#{BASE_URL}/bulk-enrich")
    req = request(Net::HTTP::Post.new(uri))
    req.body = JSON.dump({ people: people })

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    response = JSON.parse(res.body)

    # Use an open struct here?
    OpenStruct.new(
      success?: response['status'] == 'success',
      usage: OpenStruct.new(response['usage']),
      data: response.fetch('data', []).map { |data| OpenStruct.new(data) }
    )
  rescue => e
    OpenStruct.new(
      success?: false,
      error: "#{e}"
    )
  end
end
