class ApplicationConfig

  def self.method_missing(name)
    @config ||= {
        api_secret: 'G1y4YrxhIWW9A5ECjSFl',
        app_id: '3827356',
        default_coins: 100000,
        generate_championship_date: '2014-03-07',
    }
    @config[name]
  end

end