class DirectoriesController < ApplicationController
  before_action :assert_valid_dir!, only: [:browse, :scan]

  def browse
    @entries = Dir.entries(@current_path).
      sort { |x, y| x <=> y }.
      map { |e| e }
  end

  def scan
    FileEnqueuer.perform_async(@current_path.to_s)
    render json: { success: "Directory Added To Scan Queue!" }
  end

  private

  def current_path
    input_path ||= params[:path] || './'
    @current_path ||= Pathname.new(input_path).cleanpath
  end

  def assert_valid_dir!
    unless File.directory?(current_path)
      render json: { error: "invalid dir" }
    end
  end
end
