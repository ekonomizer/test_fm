#require 'coffee_script'
Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  #enable cache
  config.action_controller.perform_caching = true
  config.cache_store = :dalli_store
  config.time_zone ="Moscow"

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.session_store
  config.active_support.deprecation = :log
  config.log_level = :debug
  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true
  #config.serve_static_assets = false
  config.force_ssl = true
  config.action_dispatch.default_headers = { 'Access-Control-Allow-Origin' => '*',
                                             'Access-Control-Request-Method' => '*',
                                             'Header-Name' => 'Header-Value',
                                             'X-Frame-Options' => 'ALLOW-FROM https://vk.com',
                                             'X-XSS-Protection' => '1; mode=block',
                                             'X-Content-Type-Options' => 'nosniff'}
end
