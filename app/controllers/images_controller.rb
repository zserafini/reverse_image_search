class ImagesController < ApplicationController

  before_action :find_or_initialize_image!, only: [:inline, :find_duplicate]

  def show
    send_file File.join(params[:path]), :disposition => 'inline'
  end

  def inline
    @name = @image.name
    @name_badge = "#{@image.directory_position}/#{@image.directory.image_count}"
    @previous_page = images_inline_path( path: @image.previous_image)
    @next_page = images_inline_path( path: @image.next_image)
    @up_page = images_find_duplicate_path(path: @image.path)
  end

  def find_duplicate
    @image_count = Image.count
    @name = @image.name
    @name_badge = "#{@image.directory_position}/#{@image.directory.image_count}"
    @down_page = images_inline_path( path: @image.path)
    @previous_page = images_find_duplicate_path(path: @image.previous_image)
    @next_page = images_find_duplicate_path(path: @image.next_image)
    @up_page = directories_browse_path(path: @image.dirname)
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
