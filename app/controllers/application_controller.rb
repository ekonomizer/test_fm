class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include Authentication

  before_filter :miniprofiler
  before_action :check_auth

  private

  def check_auth
    unless params[:user_id] || params[:auth_key]
      raise "in check user: no some params - user_id = #{params[:user_id]},  auth_key = #{params[:auth_key]}"
    end
    raise "not authenticate" unless authenticate_request params
  end

  def miniprofiler
    Rack::MiniProfiler.authorize_request  if Rails.env.development?
  end
end
