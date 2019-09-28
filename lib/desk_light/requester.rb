require 'desk_light/response'
require 'open-uri'
require 'oauth'


module DeskLight
  module Requester
    def self.get *args
      _uri = URI.parse("https://#{DeskLight.config.subdomain}.desk.com" << DeskLight.config.api_path << "/" << args.first.to_s)
      _params = CGI.parse(_uri.query || "")
      _path = DeskLight.config.api_path
      args.shift
      args.each do |arg|
        case arg.class.name
        when 'Symbol','String','Integer'
          _path << "/" << arg.to_s
        when 'Hash'
          _params.merge!(arg)
        end
      end
      _url = "#{_uri.scheme}://#{_uri.host}#{_uri.path}"
      _url << "?#{URI.encode_www_form(_params)}" if _params.count > 0
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
