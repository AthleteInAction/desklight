require 'desk_light/response'
require 'open-uri'
require 'oauth'


module DeskLight
  module Requester
    def self.get _path, _params = {}
      _uri = URI.parse("https://#{DeskLight.config.subdomain}.desk.com" << _path)
      _new_params = CGI.parse(_uri.query || "").merge!(_params)
      _url = "#{_uri.scheme}://#{_uri.host}#{_uri.path}"
      _url << "?#{URI.encode_www_form(_new_params)}" if _new_params.count > 0
      consumer = OAuth::Consumer.new(
        DeskLight.config.key,
        DeskLight.config.secret,
        :scheme => :header
      )
      access_token = OAuth::AccessToken.from_hash(
        consumer,
        :oauth_token => DeskLight.config.api_token,
        :oauth_token_secret => DeskLight.config.api_secret
      )
      DeskLight::Response.new(access_token.get(_url))
    end


    def self.download _url, _authenticate = true
      uri = URI.parse(_url)
      path = uri.path
      path << "?#{uri.query}" if (uri.query || "").strip != ""
      if _authenticate
        consumer = OAuth::Consumer.new(
          DeskLight.config.key,
          DeskLight.config.secret,
          scheme: :header
        )
        access_token = OAuth::AccessToken.from_hash(
          consumer,
          oauth_token: DeskLight.config.api_token,
          oauth_token_secret: DeskLight.config.api_secret
        )
        response = access_token.get(_url)
      else
        http = Net::HTTP.new(uri.host,uri.port)
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        http.use_ssl = DeskLight.config.uri.scheme == 'https'
        request = Net::HTTP::Get.new(path)
        response = http.request(request)
      end
      if location = response['location']
        return self.download(location,false)
      end
      DeskLight::Response.new(response)
    end
  end
end
