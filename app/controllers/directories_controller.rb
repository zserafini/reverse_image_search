class DirectoriesController < ApplicationController
  before_action :assert_valid_dir!, only: [:browse, :scan]

  def browse
    @thumb = params[:thumb]

    @image_entries = DirHelper.get_images(current_path)

    @directory_entries = DirHelper.get_dirs(current_path).unshift('..')
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

  def assert_valid_dir!
    unless File.directory?(current_path)
      render json: { error: 'Bad Directory Path' }
    end
  end
end
