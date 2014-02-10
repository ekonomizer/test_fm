class ApplicationConfig

  def self.method_missing(name)
    @config ||= {
        api_secret: 'G1y4YrxhIWW9A5ECjSFl',
        app_id: '3827356',
    }
    @config[name]
  end

end