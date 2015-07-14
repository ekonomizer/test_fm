class ApplicationConfig

  require File.join(Rails.root, %w{lib tfp})

  def self.method_missing(name)
    @@config[name.to_sym]
  end

  def initialize
    @@config ||= YAML.load(Tfp.load(File.join(Rails.root, 'config', 'shared', 'shared_config.yml'))).symbolize_keys
  end

end

ApplicationConfig.new
