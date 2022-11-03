# Nymeria is our primary module namespace.
module Nymeria
  module Email
    def self.verify(email)
      uri = URI("#{BASE_URL}/email/verify")

      uri.query = URI.encode_www_form({ email: email.to_s.downcase.strip })

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

    def self.bulk_verify(*args)
      uri = URI("#{BASE_URL}/email/verify/bulk")
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
