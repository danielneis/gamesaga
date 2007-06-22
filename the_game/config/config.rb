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
      metaclass.instance_eval do
        define_method(config.to_sym) do
          @configs ||= {}
          @configs[config] = value
        end
      end
    end
  end
end
