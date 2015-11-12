class ImagesController < ApplicationController

  before_action :set_image, only: [:show, :edit, :update, :destroy]
  before_action :assert_valid_dir!, only: [:create]

  def index
    @images = Image.all
  end

  def show
  end

  def new
    @image = Image.new
  end

  def edit
  end

  def create
    Dir.chdir(@image_directory)
    image_entries = Dir.glob(['**/*.jpg', '**/*.png', '**/*.bmp', '**/*.jpeg'])

    image_entries.each do |compair_path|
      p_hash = Phashion::Image.new(compair_path).fingerprint.to_i
      Image.create(p_hash: p_hash)
    end

    respond_to do |format|
      if @image.save
        format.html { redirect_to @image, notice: 'Images were successfully created.' }
        format.json { render action: 'show', status: :created, location: @image }
      else
        format.html { render action: 'new' }
        format.json { render json: @image.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def set_image
    @image = Image.find(params[:id])
  end
end
