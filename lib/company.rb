# Nymeria is our primary module namespace.
module Nymeria
  module Company
    # args: { name: '', website: '', profile: '' }
    def self.enrich(args={})
      uri = URI("#{BASE_URL}/company/enrich")

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

    # args: { query: 'name:Nymeria', size: 10, from: 0 }
    def self.search(args={})
      uri = URI("#{BASE_URL}/company/search")

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
  end
end
