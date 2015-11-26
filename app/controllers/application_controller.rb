class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :get_global_data

  def get_global_data
    @background_job_count = Sidekiq.redis { |r| r.lrange "queue:default", 0, -1 }.length
  end
end
