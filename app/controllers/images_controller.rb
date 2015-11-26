class ImagesController < ApplicationController

  before_action :find_or_initialize_image!, only: [:inline, :find_duplicate]

  def show
    send_file File.join(params[:path]), :disposition => 'inline'
  end

  def inline
  end

  def find_duplicate
    @image_count = Image.count
    @parent_directory = directories_browse_path(path: @image.dirname)
    @name = @image.name
  end

  private

  def current_path
    input_path ||= params[:path] || './'
    current_path ||= Pathname.new(input_path).cleanpath
  end

  def find_or_initialize_image!
    @image = Image.find_or_initialize_by(path: current_path.to_s) do |i|
      i.p_hash = Phashion::Image.new(current_path.to_s).fingerprint
    end
  end

end
