require 'singleton'
require 'yaml'
class ConfigFileError < IOError; end
class Configuration

  include Singleton

  def metaclass
    class << self
      self
    end
  end

  private :metaclass

  def initialize

    @file = 'config/config.yaml'
    raise ConfigFileError, "File doesn't exists" unless File.file? @file

    @configs = YAML::load_file @file
    raise ConfigFileError, "The file is empty or isn't valid YAML" unless @configs.is_a? Hash

    @configs.each do |config, value|
      instance_variable_set("@#{config}", value)
      metaclass.instance_eval do
        attr_accessor config.to_sym
      end
    end
      
  end

  def save
    @configs.each do |config, value|
      @configs[config] = send config
    end

    File.open(@file, 'w') { |file| file << @configs.to_yaml }
  end
end
