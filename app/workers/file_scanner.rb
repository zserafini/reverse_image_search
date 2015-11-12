class FileScanner
  include Sidekiq::Worker
  sidekiq_options retry: 1

  def perform file_path
    image = Image.find_or_initialize_by(path: file_path)
    image.update(p_hash: Phashion::Image.new(file_path).fingerprint)
  end

end
