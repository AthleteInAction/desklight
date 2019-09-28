require 'desk_light/version'
require 'desk_light/configuration'
require 'desk_light/requester'


module DeskLight
  def self.configure
    @config ||= DeskLight::Configuration.new
    yield(@config) if block_given?
    @config
  end
  def self.config
    @config || self.configure
  end
  def self.get *args
    DeskLight::Requester.get(*args)
  end
  def self.download _url
    DeskLight::Requester.download(_url)
  end
end
