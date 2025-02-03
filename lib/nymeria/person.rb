# Nymeria is our primary module namespace.
module Nymeria
  module Person
    # args: { profile: '', email: '', lid: '' }
    def self.enrich(args={})
      uri = URI("#{BASE_URL}/person/enrich")

      uri.query = URI.encode_www_form(args)

      req = Nymeria::request(Net::HTTP::Get.new(uri))

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      return OpenStruct.new(JSON.parse(res.body))
    rescue => e
      OpenStruct.new(
        success?: false,
        error: "#{e}"
      )
    end

    def self.bulk_enrich(*args)
      uri = URI("#{BASE_URL}/person/enrich/bulk")

      req = Nymeria::request(Net::HTTP::Post.new(uri))
      req['Content-Type'] = 'application/json'
      req.body = JSON.dump({ requests: args })

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      return JSON.parse(res.body)
    rescue => e
      OpenStruct.new(
        success?: false,
        error: "#{e}"
      )
    end

    # args: { profile: '', email: '', lid: '' }
    def self.preview(args={})
      uri = URI("#{BASE_URL}/person/enrich/preview")

      uri.query = URI.encode_www_form(args)

      req = Nymeria::request(Net::HTTP::Get.new(uri))

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      return OpenStruct.new(JSON.parse(res.body))
    rescue => e
      OpenStruct.new(
        success?: false,
        error: "#{e}"
      )
    end

    # args: { first_name: '', last_name: '', title: '', company: '', limit: 10, offset: 0 }
    def self.search(args={})
      uri = URI("#{BASE_URL}/person/search")

      uri.query = URI.encode_www_form(args)

      req = Nymeria::request(Net::HTTP::Get.new(uri))

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      return OpenStruct.new(JSON.parse(res.body))
    rescue => e
      OpenStruct.new(
        success?: false,
        error: "#{e}"
      )
    end

    def self.retrieve(id)
      uri = URI("#{BASE_URL}/person/retrieve/#{id}")

      req = Nymeria::request(Net::HTTP::Get.new(uri))

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      return OpenStruct.new(JSON.parse(res.body))
    rescue => e
      OpenStruct.new(
        success?: false,
        error: "#{e}"
      )
    end

    def self.bulk_retrieve(*args)
      uri = URI("#{BASE_URL}/person/retrieve/bulk")

      req = Nymeria::request(Net::HTTP::Post.new(uri))
      req['Content-Type'] = 'application/json'
      req.body = JSON.dump({ requests: args })

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
        http.request(req)
      end

      return JSON.parse(res.body)
    rescue => e
      OpenStruct.new(
        success?: false,
        error: "#{e}"
      )
    end
  end
end
