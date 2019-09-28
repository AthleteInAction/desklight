require 'desk_light/version'
require 'desk_light/configuration'


module DeskLight
  def self.configure
    @config ||= DeskLight::Configuration.new
    yield(@config) if block_given?
    @config
  end
  def self.config
    @config || self.configure
  end
end
