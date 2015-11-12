class ImagesController < ApplicationController

  before_action :create_temp_image!, only: [:find_duplicate]

  def show
    send_file File.join(params[:path]), :disposition => 'inline'
  end

  def find_duplicate
    @image_count = Image.count
    @best_matches = @temp_image.get_closest_matches
  end

  private

  def current_path
    input_path ||= params[:path] || './'
    @current_path ||= Pathname.new(input_path).cleanpath
  end

  def create_temp_image!
    p_hash = Phashion::Image.new(current_path.to_s).fingerprint
    @temp_image = Image.new(p_hash: p_hash)
  end
end
