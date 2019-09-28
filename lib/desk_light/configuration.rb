module DeskLight
  class Configuration
    attr_reader :uri
    attr_accessor :subdomain
    attr_accessor :rpm
    attr_accessor :api_path
    def subdomain=(value)
      @subdomain = value
      @uri = URI.parse("https://#{@subdomain}.desk.com")
    end
    attr_accessor :email
    attr_accessor :password
    attr_accessor :key
    attr_accessor :secret
    attr_accessor :api_token
    attr_accessor :api_secret
    def initialize
      self.rpm = 300
      self.api_path = "/api/v2"
    end
    def [](value)
      self.public_send(value)
    end
  end
end
