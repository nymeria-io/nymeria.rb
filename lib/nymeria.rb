# frozen_string_literal: true

require 'json'
require 'net/http'

BASE_URL = 'https://www.nymeria.io/api/v3'
USER_AGENT = 'nymeria.rb/2.0'

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

  def self.authenticated?
    self.check_authentication.success?
  end

  def self.check_authentication
    uri = URI("#{BASE_URL}/check-authentication")
    req = request(Net::HTTP::Post.new(uri))

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    response = JSON.parse(res.body)

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

  # Accepts one or more hashes with any of the following: { url: '', identifier: '', email: '', custom: { ... } }
  def self.enrich(*args)
    if args.nil? || !args.is_a?(Array)
      return OpenStruct.new(
        success?: false,
        error: "Invalid parameter detected. Requires one or more hashes with any of the following keys; :url, ;identifier or :email."
      )
    end

    valid_keys = [:url, :identifier, :email, :custom]

    valid_args = args.select do |arg|
      arg.is_a?(Hash) && valid_keys.any? { |k| arg.keys.include?(k) }
    end

    if valid_args.length == 0
      return OpenStruct.new(
        success?: false,
        error: "Invalid parameter detected. Requires one or more hashes with any of the following keys; :url, ;identifier or :email."
      )
    end

    # Clean the args; remove any unsupported keys.
    valid_args.each do |arg|
      arg.keys.each do |key|
        arg.delete(key) unless valid_keys.include?(key)
      end
    end

    if valid_args.length == 1
      #
      # Single Enrichment
      #
      begin
        arg = valid_args.first

        uri = URI("#{BASE_URL}/enrich")
        req = request(Net::HTTP::Post.new(uri))
        req.body = JSON.dump(arg)

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end

        response = JSON.parse(res.body)

        return OpenStruct.new(
          success?: response['status'] == 'success',
          error: response['error'],
          usage: OpenStruct.new(response['usage']),
          data: OpenStruct.new(response['data'])
        )
      rescue => e
        return OpenStruct.new(
          success?: false,
          error: "#{e}"
        )
      end
    else
      #
      # Bulk Enrichment
      #
      begin
        uri = URI("#{BASE_URL}/bulk-enrich")
        req = request(Net::HTTP::Post.new(uri))
        req.body = JSON.dump({ people: args })

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(req)
        end

        response = JSON.parse(res.body)

        OpenStruct.new(
          success?: response['status'] == 'success',
          error: response['error'],
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
  end

  def self.people(query)
    begin
      uri = URI("#{BASE_URL}/people")
      uri.query = URI.encode_www_form(query)

      req = request(Net::HTTP::Get.new(uri))

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      response = JSON.parse(res.body)

      OpenStruct.new(
        success?: response['status'] == 'success',
        error: response['error'],
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

  def self.reveal(uuids)
    begin
      uri = URI("#{BASE_URL}/people")
      req = request(Net::HTTP::Post.new(uri))
      req.body = JSON.dump({ uuids: uuids })

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      response = JSON.parse(res.body)

      OpenStruct.new(
        success?: response['status'] == 'success',
        error: response['error'],
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
end
