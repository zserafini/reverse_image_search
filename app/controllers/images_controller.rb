class ImagesController < ApplicationController

  before_action :create_temp_image!, only: [:find_duplicate]

  def show
    send_file File.join(params[:path]), :disposition => 'inline'
  end

  def inline
    current_path
    @previous_path = File.join(current_path.dirname, current_directory_entries[(current_directory_position%(current_directory_entries.count-1))+1])
    @next_path = File.join(current_path.dirname, current_directory_entries[current_directory_position-1])
  end

  def find_duplicate
    @image_count = Image.count
    @best_matches = @temp_image.get_closest_matches
    @previous_path = File.join(current_path.dirname, current_directory_entries[(current_directory_position%(current_directory_entries.count-1))+1])
    @next_path = File.join(current_path.dirname, current_directory_entries[current_directory_position-1])
  end

  private

  def current_path
    input_path ||= params[:path] || './'
    @current_path ||= Pathname.new(input_path).cleanpath
  end

  def current_directory_entries
    @current_directory_entries ||= DirHelper.get_images(current_path.dirname)
  end

  def current_directory_position
    @current_directory_position ||= current_directory_entries.index(current_path.basename.to_s)
  end

  def create_temp_image!
    p_hash = Phashion::Image.new(current_path.to_s).fingerprint
    @temp_image = Image.new(p_hash: p_hash, path: current_path.to_s)
  end

end
