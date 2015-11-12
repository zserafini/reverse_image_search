class DirectoriesController < ApplicationController
  before_action :assert_valid_dir!, only: [:browse, :scan]

  def browse
    @thumb = params[:thumb]

    @image_entries = Dir.entries(@current_path).
      keep_if { |x| (x =~ /\.jpg$|\.png$|\.jpeg$|\.bmp$/) }.
      sort { |x, y| x <=> y }

    @directory_entries = Dir.entries(@current_path).
      select { |f| File.directory? File.join(@current_path, f) and !(f == '.') }.
      sort { |x, y| x <=> y }
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
      render json: { error: 'Bad Directory Path' }
    end
  end
end
