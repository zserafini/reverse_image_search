class DirectoriesController < ApplicationController
  before_action :find_or_initialize_dir!, only: [:browse, :scan]

  def browse
    @directory = Directory.find_or_initialize_by(path: @current_path)
    @scan_link = directories_scan_path(path: @current_path)
    @scan_and_clear_link = directories_scan_path(path: @current_path, clear: true)
    @name = @directory.name
    @name_badge = @directory.image_count
    @previous_page = directories_browse_path(path: @directory.next_directory) 
    @next_page = directories_browse_path(path: @directory.previous_directory) 
    @up_page =directories_browse_path(path: @directory.parent_directory.path) 
  end

  def scan
    if params[:clear]
      Sidekiq::Queue.all.each(&:clear)
      Image.delete_all
    end
    FileEnqueuer.perform_async(@current_path)
    flash[:notice] = 'Successfully enqueued background scan'
    redirect_to directories_browse_path(path: @current_path)
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
