begin
  include VkApiRequests
  p 'Start init access token'
  create_app_access_token
  p 'access token initialized'
rescue Exception => e
  raise 'API not initialized and access_token not send' if Rails.env.include?('production')
end


