class DirectoriesController < ApplicationController
  before_action :find_or_initialize_dir!, only: [:browse, :scan]

  def browse
    @thumb = params[:thumb]

    @image_entries = @directory.images

    @directory_entries = @directory.sub_directories.unshift('..')
  end

  def scan
    FileEnqueuer.perform_async(@current_path)
    render json: { success: "Directory Added To Scan Queue!" }
  end

  private

  def current_path
    input_path ||= params[:path] || './'
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
