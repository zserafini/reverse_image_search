class DirectoriesController < ApplicationController
  before_action :find_or_initialize_dir!, only: [:browse, :scan]

  def browse
    @directory = Directory.find_or_initialize_by(path: @current_path)
    @scan_link = directories_scan_path(path: @current_path)
    @parent_directory = directories_browse_path(path: @directory.dirname)
    @name = @directory.name
    @previous_page = directories_browse_path(path: @directory.next_directory) 
    @next_page = directories_browse_path(path: @directory.previous_directory) 
    @up_page =directories_browse_path(path: @directory.parent_directory.path) 
  end

  def scan
    FileEnqueuer.perform_async(@current_path)
    render json: { success: "Directory Added To Scan Queue!" }
  end

  private

  def current_path
    input_path ||= params[:path] || Rails.root.to_s
    @current_path ||= Pathname.new(input_path).cleanpath.to_s
  end

  def find_or_initialize_dir!
    assert_valid_dir!
    @directory = Directory.find_or_initialize_by(path: current_path)
  end

  def assert_valid_dir!
    unless File.directory?(current_path)
      render json: { error: 'Bad Directory Path' }
    end
  end
end
