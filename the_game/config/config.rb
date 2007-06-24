require 'singleton'
require 'yaml'
class Configuration

  include Singleton

  def metaclass
    class << self
      self
    end
  end

  private :metaclass

  def initialize
    configuration = YAML::load_file 'config/config.yaml'

    configuration.each do |config, value|
      instance_variable_set("@#{config}", value)
      @configurations ||= {}
      @configurations[config] = value
      metaclass.instance_eval do
        attr_accessor config.to_sym
      end
    end
  end
end
